//
//  MapStorage.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/28/23.
//

import Foundation
import ArcGIS


protocol MapStorageProtocol {
    func saveMap(map: OfflineStoredMap)
    func deleteMap(mapId: String)
    func loadAllMap() -> [MapItem]
}

struct CoreDataMapStorage: MapStorageProtocol {
    private let persistent = PersistenceController.instance
    
    func saveMap(map: OfflineStoredMap) {
        persistent.saveMap(map: map)
    }
    
    func deleteMap(mapId: String) {
        //persistent.saveMap(map: <#T##OfflineStoredMap#>)
    }
    
    func loadAllMap() -> [MapItem] {
        let map = persistent.fetchAllMaps()
        switch map {
        case .success(let result):
            return result
        case .failure(let err):
            print("Error at loadAllMap - CoreDataMapStorage")
            return []
        }
    }
    
    
}
