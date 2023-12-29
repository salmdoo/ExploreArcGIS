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
        item: PortalItem.exploreMaine()))
}
