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
    
    init?(preplannedMapArea: PreplannedMapArea, offlineMapTask: OfflineMapTask, temporaryDirectory: URL, storageMap: MapStorageProtocol) {
        self.preplannedMapArea = preplannedMapArea
        self.offlineMapTask = offlineMapTask
        self.storageMap = storageMap
        
        if let itemID = preplannedMapArea.portalItem.id {
            self.mmpkDirectory = temporaryDirectory
                .appendingPathComponent(itemID.rawValue)
                .appendingPathExtension("mmpk")
        } else {
            return nil
        }
        
        super.init(portalItem: preplannedMapArea.portalItem)
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
extension OfflinePreplannedMap: OfflineMapProtocol {
    
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
        storageMap.saveMap(map: OfflineStoredMap(map: self))
        
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
    
    /// Cancels current download.
    func cancelDownloading() async {
        guard let job else {
            return
        }
        await job.cancel()
        self.job = nil
    }
    
    /// Removes the downloaded offline map (mmpk) from disk.
    func removeDownloaded() {
        result = nil
        try? FileManager.default.removeItem(at: mmpkDirectory)
    }
    
    func loadDownloaded() -> Map? {
        if downloadDidSucceed {
            if case .success(let mmpk) = result {
                // If we have already downloaded, then open the map in the mmpk.
                return mmpk.maps.first
            }
        }
        return nil
    }
}

extension FileManager {
    /// Creates a temporary directory and returns the URL of the created directory.
    static func createTemporaryDirectory() -> URL {
        // swiftlint:disable:next force_try
        try! FileManager.default.url(
            for: .itemReplacementDirectory,
            in: .userDomainMask,
            appropriateFor: FileManager.default.temporaryDirectory,
            create: true
        )
    }
}
