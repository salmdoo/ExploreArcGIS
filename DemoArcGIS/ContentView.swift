//
//  ContentView.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/20/23.
//

import SwiftUI
import ArcGIS


struct ContentView: View {
    
    @State private var model = MapModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    Section {
                        if let onlineMap = model.webmapOnline as? OnlineMap {
                            NavigationLink {
                                WebMapView(map: onlineMap.map)
                            } label: {
                                MapItemView(model: onlineMap)
                            }
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationTitle("Explore Maine")
                        }
                        
                        
                    } header: {
                        Text("Web View")
                            .font(.title)
                            .bold()
                    }
                    if let preplannedMaps = model.offlineMapModels {
                        Section {
                            switch preplannedMaps {
                            case .success(let maps):
                                ForEach (maps) {mapItem in
                                    PreplannedMapItemView(model: mapItem)
                                }
                            case .failure (let error):
                                Text(error.localizedDescription)
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
}

#Preview {
    ContentView()
}
