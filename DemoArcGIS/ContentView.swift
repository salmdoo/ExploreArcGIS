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
        NavigationView {
            List {
                Section {
                    if let onlineMap = model.webmapOnline as? OnlineMap {
                        NavigationLink {
                           WebMapView(map: onlineMap.map)
                        } label: {
                            MapItemView(model: MapItem(thumbnailUrl: model.portalItem.thumbnail?.url, title: model.portalItem.title, snippet: model.portalItem.snippet))
                                .foregroundColor(.black)
                        }
                       
                        
                    }
                    
                    
                } header: {
                    Text("Web View")
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
                        Text("Map Areas")
                            .bold()
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Explore Maine")
    }.listStyle(PlainListStyle())
    
            
    }
}

#Preview {
    ContentView()
}
