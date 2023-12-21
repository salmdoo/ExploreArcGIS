//
//  OfflineMapModel.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import ArcGIS

@Observable
class OfflineMapModel: Identifiable {
    let preplannedMapArea: PreplannedMapArea
    
    
    init(preplannedMapArea: PreplannedMapArea) {
        self.preplannedMapArea = preplannedMapArea
    }
}
