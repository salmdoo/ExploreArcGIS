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
    private let portalItem: PortalItem
    
    var onlineMapModel: MapItem? = nil
    
    private let offlineMapTask: OfflineMapTask
    
    // A URL to a temporary directory where the downloaded map packages are stored.
    private let temporaryDirectory: URL

    var offlineMapModels: Result<[MapItem], Error>?

    private let storageMap: MapStorageProtocol
    
    init(storageMap: MapStorageProtocol, portalId: String, temporaryDirectory: URL) {
        self.portalItem = PortalItem.exploreMaine(id: portalId)
        // Creates temp directory.
        self.temporaryDirectory = temporaryDirectory
        self.storageMap = storageMap
        
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
     static func exploreMaine(id: String) -> PortalItem {
        PortalItem(portal: .arcGISOnline(connection: .anonymous),
                   id: PortalItem.ID(id)!)
    }
}


