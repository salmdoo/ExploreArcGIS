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
    
    var webmapOnline: MapItem
    
    private let offlineMapTask: OfflineMapTask
    
    // A URL to a temporary directory where the downloaded map packages are stored.
    private let temporaryDirectory: URL

    private(set) var offlineMapModels: Result<[MapItem], Error>?

    private let storageMap: MapStorageProtocol
    
    init() {
        
        
        // Creates temp directory.
        temporaryDirectory = FileManager.createTemporaryDirectory()
        storageMap = CoreDataMapStorage(temporaryDirectory: temporaryDirectory)
        
        // Initializes the online map and offline map task.
        offlineMapTask = OfflineMapTask(portalItem: portalItem)
        webmapOnline = OnlineMap(portalItem: portalItem)
        Task {
            await makeOfflineMapModels()
        }
    }
    
    func makeOfflineMapModels() async {
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
                            storageMap: storageMap
                        )
                        
                    }
                filtered = offlinePreplannedMap.filter { !offlineStoredMapTemp.map({ $0.title }).contains($0.title) }
            }
            return offlineStoredMapTemp + filtered
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


