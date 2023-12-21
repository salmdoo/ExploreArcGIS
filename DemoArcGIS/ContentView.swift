//
//  ContentView.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/20/23.
//

import SwiftUI
import ArcGIS

struct ContentView: View {
    
    @StateObject private var model = Model()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if let _ = model.webMap {
                    Section {
                        MapItem(thumbnail: model.portalItem.thumbnail?.url, title: model.portalItem.title, description: model.portalItem.snippet)
                    } header: {
                        Text("Web View")
                            .font(.title)
                            .bold()
                    }
                }
                
                if let preplannedMaps = model.offlineMapModels {
                    Section {
                        switch preplannedMaps {
                        case .success(let maps):
                            ForEach (maps) {mapItem in
                                let item = mapItem.preplannedMapArea.portalItem
                                MapItem(thumbnail: item.thumbnail?.url, title: item.title, description: item.snippet, showOption: true)
                            }
                        case .failure(let err):
                            Text("Err")
                        }
                    } header: {
                        Text("Map Area")
                            .font(.title)
                            .bold()
                    }
                    
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
