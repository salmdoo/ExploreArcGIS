//
//  PreplannedMapAreaSelectionView.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/27/23.
//

import SwiftUI
import ArcGIS

struct PreplannedMapItemView: View {
    
    var model: MapItem
    @State private var clickDelete: Bool = false
    
    var body: some View {
        HStack {
            if let offlineStored = model as? OfflineStoredMap {
                NavigationLink {
                    MapDetailsView(map: model)
                   
                } label: {
                    MapItemView(model: model)
                }.disabled(!offlineStored.canViewDetails)
                Spacer()
                switch offlineStored.result {
                case .none:
                    Button(action: {
                        clickDelete = true
                    }, label: {
                        Image(systemName: "trash")
                            .iconBackground()
                            .foregroundColor(.red)
                    }).alert(isPresented: $clickDelete) {
                        Alert(
                            title: Text("Delete Confirmation"),
                            message: Text("Are you sure you want to delete this map?"),
                            primaryButton: .destructive(Text("Delete")) {
                                offlineStored.removeMap()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                case .success(_ ):
                    Image(systemName: "eye.trianglebadge.exclamationmark")
                        .iconBackground()
                case .failure:
                    Image(systemName: "exclamationmark.circle")
                        .iconBackground()
                        .foregroundColor(.red)
                }
            }
            
            
            if let offlineModel = model as? OfflinePreplannedMap {
                MapItemView(model: model)
                
                Spacer()
            
                if offlineModel.isDownloading, let job = offlineModel.job {
                    
                    ProgressView(job.progress)
                        .iconBackground()
                        .progressViewStyle(CircularProgressViewStyle())
                        .labelsHidden()
                } else {
                    
                    switch offlineModel.result {
                    case .success:
                        EmptyView()
                    case .failure:
                        Image(systemName: "exclamationmark.circle")
                            .iconBackground()
                            .foregroundColor(.red)
                    case .none:
                        Button(action: {
                            Task {
                                await offlineModel.download()
                            }
                        }, label: {
                            Image(systemName: "icloud.and.arrow.down")
                                .iconBackground()
                                .foregroundColor(.black)
                        })
                    }
                    
                }
            }
        }
    }
}

struct IconBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(7)
            .background(Circle().foregroundColor(Color(white: 0.2, opacity: 0.1)))
            .padding()
    }
}
extension Image {
    func iconBackground() -> some View {
        self.modifier(IconBackground())
    }
}
extension ProgressView {
    func iconBackground() -> some View {
        self.modifier(IconBackground())
    }
}
