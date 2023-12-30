//
//  DemoArcGISApp.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/20/23.
//

import SwiftUI

@main
struct DemoArcGISApp: App {
    @State private var networkMonitor = NetworkMonitor.instance
    private let temporaryDirectory = FileManager.createTemporaryDirectory()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: MapModel(storageMap: CoreDataMapStorage(temporaryDirectory: temporaryDirectory),
                                        portalId: "3bc3179f17da44a0ac0bfdac4ad15664", temporaryDirectory: temporaryDirectory))
                .environmentObject(networkMonitor)
        }
    }
}
