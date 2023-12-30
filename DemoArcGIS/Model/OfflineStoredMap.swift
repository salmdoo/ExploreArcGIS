//
//  OfflineStoredMap.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/28/23.
//

import Foundation
import ArcGIS

@Observable
class OfflineStoredMap: MapItem {
    
    private let mapStorage: MapStorageProtocol?
    private var mmpkDirectory: URL? = nil
    private(set) var result: Result<Bool, Error>?
    private(set) var canViewDetails = true
    
    override func loadMap() async -> Map? {
        if let fileURL = mmpkDirectory {
            
            let mapPackage = MobileMapPackage(fileURL: fileURL)
            do {
               try await mapPackage.load()
                return mapPackage.maps.first
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func removeDownloaded() {
        do{
            try mapStorage?.deleteMap(mapId: id)
            canViewDetails = false
            result = .success(true)
        } catch {
            result = .failure(error)
        }
        if let fileURL = mmpkDirectory {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
    
    init(offlineModel: MapOffline, mapStorage: MapStorageProtocol, temporaryDirectory: URL) {
        self.mapStorage = mapStorage
        self.mmpkDirectory = FileManager.createMMPKTemporaryDirectory(temporaryDirectory: temporaryDirectory, fileName: offlineModel.id)
        super.init(id: offlineModel.id, thumbnailUrl: offlineModel.thumbnailUrl, title: offlineModel.title, snippet: offlineModel.snippet)
    }
    
    init(map: OfflinePreplannedMap, mapStorage: MapStorageProtocol, temporaryDirectory: URL) {
        self.mapStorage = mapStorage
        self.mmpkDirectory = FileManager.createMMPKTemporaryDirectory(temporaryDirectory: temporaryDirectory, fileName: map.id)
        super.init(portalItem: map.preplannedMapArea.portalItem)
    }
    
}
