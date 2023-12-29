//
//  MapStorage.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/28/23.
//

import Foundation
import ArcGIS


protocol MapStorageProtocol {
    func saveMap(map: OfflineStoredMap) throws
    func deleteMap(mapId: String) throws
    func loadAllMap() throws -> [MapItem]
}

struct CoreDataMapStorage: MapStorageProtocol {
    private let persistent = PersistenceController.instance
    let temporaryDirectory: URL
    
    func saveMap(map: OfflineStoredMap) throws {
        try persistent.saveMap(map: map)
    }
    
    func deleteMap(mapId: String) throws {
        try persistent.deleteMap(id: mapId)
    }
    
    func loadAllMap() throws -> [MapItem] {
        let results = try persistent.fetchAllMaps()
        return results.compactMap { OfflineStoredMap(offlineModel: $0, mapStorage: self, temporaryDirectory: temporaryDirectory)}
    }
    
    
}
