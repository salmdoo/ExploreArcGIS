//
//  MapItem.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/21/23.
//

import SwiftUI
import ArcGIS

struct MapItemView: View {
    let model: MapItem
    
    init(model: MapItem) {
        self.model = model
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: model.thumbnailUrl) { img in
                img.resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "photo")
            }
            .frame(width: 100, height: 100, alignment: .center)
            
            VStack (alignment: .leading) {
                if let title = model.title  {
                    Text(title)
                        .font(.title3)
                }
                
                if let snippet = model.snippet {
                    Text(snippet)
                        .font(.subheadline)
                        .opacity(0.6)
                }
            }
        }.frame(maxHeight: 100)
    }
}

#Preview {
    MapItemView(model: MapItem.previewData())
}


