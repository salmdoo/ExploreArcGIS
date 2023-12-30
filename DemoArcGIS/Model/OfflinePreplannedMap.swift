//
//  OfflineMapModel.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import ArcGIS



@Observable
/// An object that encapsulates state about an offline map.
final class OfflinePreplannedMap: MapItem {
    
    /// The preplanned map area.
    let preplannedMapArea: PreplannedMapArea
    
    /// The task to use to take the area offline.
    let offlineMapTask: OfflineMapTask
    
    /// The directory where the mmpk will be stored.
    let mmpkDirectory: URL
    
    /// The currently running download job.
   private(set) var job: DownloadPreplannedOfflineMapJob?
    
    /// The result of the download job.
    private(set) var result: Result<MobileMapPackage, Error>?
    
    private let storageMap: MapStorageProtocol
    private let temporaryDirectory: URL
    
    init?(preplannedMapArea: PreplannedMapArea, offlineMapTask: OfflineMapTask, temporaryDirectory: URL, storageMap: MapStorageProtocol, model: MapModel?) {
        self.preplannedMapArea = preplannedMapArea
        self.offlineMapTask = offlineMapTask
        self.storageMap = storageMap
        self.temporaryDirectory = temporaryDirectory
        
        if let itemID = preplannedMapArea.portalItem.id,
           let fileURL =  FileManager.createMMPKTemporaryDirectory(temporaryDirectory: temporaryDirectory, fileName: itemID.rawValue) {
            self.mmpkDirectory = fileURL
            
        } else {
            return nil
        }
        
        super.init(portalItem: preplannedMapArea.portalItem, model: model)
    }
    
    deinit {
        Task { [job] in
            // Cancel any outstanding job.
            await job?.cancel()
           
        }
    }
}


extension OfflinePreplannedMap {
    /// A Boolean value indicating whether the map is being taken offline.
    var isDownloading: Bool {
        job != nil
    }
}

@MainActor
extension OfflinePreplannedMap {
    
    /// Downloads the given preplanned map area.
    /// - Parameter preplannedMapArea: The preplanned map area to be downloaded.
    /// - Precondition: `canDownload`
    func download() async {
        precondition(canDownload)
        
        let parameters: DownloadPreplannedOfflineMapParameters
        
        do {
            // Creates the parameters for the download preplanned offline map job.
            parameters = try await makeParameters(area: preplannedMapArea)
            
        } catch {
            // If creating the parameters fails, set the failure.
            self.result = .failure(error)
            return
        }
        
        // Creates the download preplanned offline map job.
        self.job = offlineMapTask.makeDownloadPreplannedOfflineMapJob(
            parameters: parameters,
            downloadDirectory: mmpkDirectory
        )
        
        // Starts the job.
        self.job?.start()
        
        // Awaits the output of the job and assigns the result.
        result = await self.job?.result.map { $0.mobileMapPackage }
        
        // Save map to local
        let storedMap = OfflineStoredMap(map: self, mapStorage: storageMap, temporaryDirectory: self.temporaryDirectory)
        try? storageMap.saveMap(map: storedMap)
        model?.replaceOfflineMap(map: storedMap)
        
        // Sets the job to nil
        self.job = nil
    }
    
    /// A Boolean value indicating whether the offline map can be downloaded.
    /// This returns `false` if the map was already downloaded successfully or is in the process
    /// of being downloaded.
    var canDownload: Bool {
        !(isDownloading || downloadDidSucceed)
    }
    
    /// A Boolean value indicating whether the download succeeded.
    var downloadDidSucceed: Bool {
        if case .success = result {
            return true
        } else {
            return false
        }
    }
    
    /// Creates the parameters for a download preplanned offline map job.
    /// - Parameter preplannedMapArea: The preplanned map area to create parameters for.
    /// - Returns: A `DownloadPreplannedOfflineMapParameters` if there are no errors.
    func makeParameters(area: PreplannedMapArea) async throws -> DownloadPreplannedOfflineMapParameters {
        // Creates the default parameters.
        let parameters = try await offlineMapTask.makeDefaultDownloadPreplannedOfflineMapParameters(preplannedMapArea: area)
        // Sets the update mode to no updates as the offline map is display-only.
        parameters.updateMode = .noUpdates
        return parameters
    }
    
}

