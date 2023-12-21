//
//  WebMapView.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/20/23.
//

import SwiftUI
import ArcGIS

struct WebMapView: View {
    
    @State private var map = Map(
        item: PortalItem(portal: .arcGISOnline(connection: .anonymous), id: PortalItem.ID("3bc3179f17da44a0ac0bfdac4ad15664")!))
    
    var body: some View {
        MapView(map: map)
    }
}

#Preview {
    WebMapView()
}
