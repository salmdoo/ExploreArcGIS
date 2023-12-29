//
//  WebMapView.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/20/23.
//

import SwiftUI
import ArcGIS

struct WebMapView: View {
    let map: Map?
    
    var body: some View {
        if let map {
            MapView(map: map)
        }
    }
}

#Preview {
    WebMapView(map: Map(
        item: PortalItem(portal: .arcGISOnline(connection: .anonymous), id: PortalItem.ID("3bc3179f17da44a0ac0bfdac4ad15664")!)))
}
