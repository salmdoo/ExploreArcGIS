//
//  OfflineMapModel.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import ArcGIS

class OfflineMapModel: ObservableObject,Identifiable {
    let preplannedMapArea: PreplannedMapArea
    
    
    init(preplannedMapArea: PreplannedMapArea) {
        self.preplannedMapArea = preplannedMapArea
    }
}
