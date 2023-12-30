//
//  ContentView.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/20/23.
//

import SwiftUI
import ArcGIS


struct ContentView: View {
    
    @State private var model: MapModel
    
    init(model: MapModel) {
        self.model = model
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let onlineMap = model.onlineMapModel as? OnlineMap, let item = onlineMap.portalItem {
                    Section {
                        NavigationLink {
                            MapDetailsView(map: onlineMap)
                        } label: {
                            MapItemView(model: MapItem(portalItem: item))
                        }
                    } header: {
                        Text("Web View")
                            .bold()
                    }
                }
                
                Section {
                    if model.loading {
                        Text("Loading preplanned map ...")
                            .font(.caption)
                    }
                    switch model.offlineMapModels {
                    case .success(let maps):
                        ForEach (maps.indices, id: \.self) {idx in
                            PreplannedMapItemView(model: maps[idx])
                        }
                    case .failure (let error):
                        Text(error.localizedDescription)
                    case .none:
                        EmptyView()
                    }
                } header: {
                    Text("Map Areas")
                        .bold()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Explore Maine")
            .onChange(of: model.networkMonitor.isConnected, {
                Task {
                   await model.loadMaps()
                }
            })
    }
    .listStyle(PlainListStyle())
    .refreshable {
        Task{
            await model.loadMaps()
        }
    }
    }
}

struct MapDetailsView: View {
    let map: MapItem?
    @State private var mapData: Map? = nil
    
    var body: some View {
        if let data = mapData {
            MapView(map: data)
        } else {
           Image(systemName: "rays")
            .onAppear() {
                Task {
                    mapData = await map?.loadMap()
                }
            }
        }
    }
}

