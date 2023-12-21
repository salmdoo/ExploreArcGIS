//
//  MapModel.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/21/23.
//

import Foundation
import Combine
import ArcGISToolkit
import ArcGIS

@MainActor
class Model: ObservableObject {
   let portalItem = PortalItem.exploreMaine()
    
    @Published var webMap: Map?
    
    private let offlineMapTask: OfflineMapTask
    @Published private(set) var offlineMapModels: Result<[OfflineMapModel], Error>?
    
    init() {
        self.webMap = Map(item: portalItem)
        self.offlineMapTask = OfflineMapTask(portalItem: portalItem)
        Task {
            await makeOfflineMapModels()
        }
    }
    
    
    func makeOfflineMapModels() async {
        self.offlineMapModels = await Result {
            try await offlineMapTask.preplannedMapAreas
                .sorted(using: KeyPathComparator(\.portalItem.title))
                .compactMap {
                    OfflineMapModel(preplannedMapArea: $0 )
                }
        }
    }
    
}

private extension PortalItem {
    static func exploreMaine() -> PortalItem {
        PortalItem(portal: .arcGISOnline(connection: .anonymous), id: PortalItem.ID("3bc3179f17da44a0ac0bfdac4ad15664")!)
    }
}
