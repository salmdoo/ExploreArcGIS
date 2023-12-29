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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkMonitor)
        }
    }
}
