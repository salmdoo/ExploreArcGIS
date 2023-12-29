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
                }
                .onAppear(){
                    Task {
                        downloadedMap = await offlineStored.loadDownloaded()
                    }
                }
                Spacer()
                Button(action: {
                    offlineStored.removeDownloaded()
                }, label: {
                    Image(systemName: "trash")
                        .iconBackground()
                        .foregroundColor(.red)
                })

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
                        .progressViewStyle(.gauge)
                        .padding()
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

/// A circular gauge progress view style.
private struct GaugeProgressViewStyle: ProgressViewStyle {
    private var strokeStyle: StrokeStyle { .init(lineWidth: 3, lineCap: .round) }
    
    func makeBody(configuration: Configuration) -> some View {
        if let fractionCompleted = configuration.fractionCompleted {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), style: strokeStyle)
                Circle()
                    .trim(from: 0, to: fractionCompleted)
                    .stroke(.gray, style: strokeStyle)
                    .rotationEffect(.degrees(-90))
            }
            .fixedSize()
        }
    }
}

private extension ProgressViewStyle where Self == GaugeProgressViewStyle {
    /// A progress view that visually indicates its progress with a gauge.
    static var gauge: Self { .init() }
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
