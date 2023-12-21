//
//  MapItem.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/21/23.
//

import SwiftUI

struct MapItem: View {
    let thumbnail: URL?
    let title: String?
    let description: String?
    let showOption: Bool
    
    init(thumbnail: URL?, title: String?, description: String?, showOption: Bool = false) {
        self.thumbnail = thumbnail
        self.title = title
        self.description = description
        self.showOption = showOption
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: thumbnail) { img in
                img.resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "photo")
            }
            .frame(width: 100, height: 100, alignment: .center)
            
            VStack (alignment: .leading) {
                if let title  {
                    Text(title)
                        .font(.title)
                }
                
                if let description {
                    Text(description)
                }
            }
            Spacer()
            if showOption {
                Image(systemName: "icloud.and.arrow.down")
                    .padding()
            }
        }.frame(maxHeight: 100)
    }
}

#Preview {
    MapItem(thumbnail: URL(string: "https://www.arcgis.com/sharing/rest/content/items/ 3bc3179f17da44a0acObfdac4ad15664/info/ thumbnail/ago_downloaded.png"), title: "Bonston Circle", description: "It lies on Massachusetts Bay, an arm of the Atlantic Ocean. The city proper has an unusually small area for a major city")
}
