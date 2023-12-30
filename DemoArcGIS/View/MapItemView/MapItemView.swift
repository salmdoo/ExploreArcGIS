//
//  MapItem.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/21/23.
//

import SwiftUI
import ArcGIS
import SDWebImageSwiftUI

struct MapItemView: View {
    let model: MapItem
    
    init(model: MapItem) {
        self.model = model
    }
    
    var body: some View {
        HStack {
            if let thumbnailUrl = model.thumbnailUrl {
                WebImage(url: thumbnailUrl)
                    .resizable()
                    .placeholder(Image(systemName: "photo"))
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .scaledToFill()
                    .frame(width: 100, height: 70, alignment: .center)
            }
            
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
            .foregroundColor(.black)
    }
}

#Preview {
    MapItemView(model: MapItem.previewData())
}


