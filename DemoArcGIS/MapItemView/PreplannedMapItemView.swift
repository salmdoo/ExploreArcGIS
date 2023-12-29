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

    @State var downloadedMap: Map?
    var body: some View {
        HStack {
            if let offlineStored = model as? OfflineStoredMap {
                NavigationLink {
                    if let downloadedMap {
                        WebMapView(map: downloadedMap)
                    }
                } label: {
                    MapItemView(model: model)
                        .foregroundColor(.black)
                }.disabled(!offlineStored.canViewDetails)
                .onAppear(){
                    Task {
                        downloadedMap = await offlineStored.loadDownloaded()
                    }
                }
                Spacer()
                switch offlineStored.result {
                case .none:
                    Button(action: {
                        offlineStored.removeDownloaded()
                    }, label: {
                        Image(systemName: "trash")
                            .iconBackground()
                            .foregroundColor(.red)
                    })
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
                NavigationLink {
                    if offlineModel.downloadDidSucceed {
                        WebMapView(map: offlineModel.loadDownloaded())
                    }
                } label: {
                    MapItemView(model: model)
                        .foregroundColor(.black)
                }.disabled(!offlineModel.downloadDidSucceed)
                
                Spacer()
            
                if offlineModel.isDownloading, let job = offlineModel.job {
                    
                    ProgressView(job.progress)
                        .iconBackground()
                        .progressViewStyle(CircularProgressViewStyle())
                        .labelsHidden()
                } else {
                    
                    switch offlineModel.result {
                    case .success:
                        Button(action: {
                            offlineModel.removeDownloaded()
                        }, label: {
                            Image(systemName: "trash")
                                .iconBackground()
                                .foregroundColor(.red)
                        })
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
