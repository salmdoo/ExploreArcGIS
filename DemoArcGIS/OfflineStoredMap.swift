//
//  OfflineStoredMap.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/28/23.
//

import Foundation
import ArcGIS

class OfflineStoredMap: MapItem, OfflineMapProtocol {
    
    private let persistent: MapStorageProtocol? = nil
    
    @MainActor
    func loadDownloaded() async -> Map? {
        if let mapURL {
            let mapPackage = MobileMapPackage(fileURL: mapURL)
            
            do {
               try await mapPackage.load()
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func removeDownloaded() {
        if let title {
            persistent?.deleteMap(mapId: title)
        }
    }
    
    private(set) var mapURL: URL?
    
    init(mapURL: URL, thumbnailUrl: URL, title: String, snippet: String) {
        
        self.mapURL = mapURL
        super.init(thumbnailUrl: thumbnailUrl, title: title, snippet: snippet)
    }
    
    init(offlineModel: MapOffline) {
        self.mapURL = offlineModel.mapFile
        super.init(thumbnailUrl: offlineModel.thumbnailUrl, title: offlineModel.title, snippet: offlineModel.snippet)
    }
    
    init(map: OfflinePreplannedMap) {
        self.mapURL = map.mmpkDirectory
        super.init(thumbnailUrl: map.thumbnailUrl, title: map.title, snippet: map.snippet)
    }
    
}
