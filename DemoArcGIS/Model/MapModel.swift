//
//  MapModel.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import Combine
import ArcGISToolkit
import ArcGIS

@Observable
class MapModel {
    
    /// A portal item displaying the Explore Maine
     let portalItem = PortalItem.exploreMaine()
    
    var onlineMapModel: MapItem? = nil
    
    private let offlineMapTask: OfflineMapTask
    
    // A URL to a temporary directory where the downloaded map packages are stored.
    private let temporaryDirectory: URL

    var offlineMapModels: Result<[MapItem], Error>?

    private let storageMap: MapStorageProtocol
    
    init() {
        // Creates temp directory.
        temporaryDirectory = FileManager.createTemporaryDirectory()
        storageMap = CoreDataMapStorage(temporaryDirectory: temporaryDirectory)
        
        // Initializes the online map and offline map task.
        offlineMapTask = OfflineMapTask(portalItem: portalItem)
        
        Task {
            await loadMaps()
        }
    }
    
    func loadMaps() async {
        
        if NetworkMonitor.instance.isConnected {
            onlineMapModel = OnlineMap(portalItem: portalItem)
        } else { onlineMapModel = nil }
        
        offlineMapModels = await Result {
            let offlineStoredMapTemp = try storageMap.loadAllMap()
            
            var filtered: [MapItem] = []
            
            if NetworkMonitor.instance.isConnected {
                let offlinePreplannedMap =
                try await offlineMapTask.preplannedMapAreas
                    .compactMap {
                        OfflinePreplannedMap(
                            preplannedMapArea: $0,
                            offlineMapTask: offlineMapTask,
                            temporaryDirectory: temporaryDirectory,
                            storageMap: storageMap,
                            model: self
                        )
                        
                    }
                filtered = offlinePreplannedMap.filter { !offlineStoredMapTemp.map({ $0.id }).contains($0.id) }
            }
             return offlineStoredMapTemp + filtered
        }
    }
    
    func replaceOfflineMap(map: MapItem) {
        switch offlineMapModels {
        case .success(var maps):
            for (idx, val) in maps.enumerated() {
                if val.id == map.id {
                    maps[idx] = map
                }
            }
            offlineMapModels = Result.success(maps)
        case .failure( let error):
            offlineMapModels = Result.failure(error)
        case .none:
            print("Do nothing")
        }
        
    }
    
    deinit {
        try? FileManager.default.removeItem(at: temporaryDirectory)
    }
    
}

//fileprivate
 extension PortalItem {
    static func exploreMaine() -> PortalItem {
        PortalItem(portal: .arcGISOnline(connection: .anonymous),
                   id: PortalItem.ID("3bc3179f17da44a0ac0bfdac4ad15664")!)
    }
}


