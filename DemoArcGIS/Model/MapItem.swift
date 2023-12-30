//
//  MapItem.swift
//  DemoArcGIS
//
//  Created by Salmdo on 12/28/23.
//

import Foundation
import ArcGIS

@Observable
class MapItem: Identifiable {
    weak var model: MapModel?
    
    var portalItem: PortalItem? = nil
    private(set) var id : String
    let thumbnailUrl: URL?
    let title: String?
    let snippet: String?
    
    init(portalItem: PortalItem, model: MapModel? = nil) {
        self.portalItem = portalItem
        self.thumbnailUrl = portalItem.thumbnail?.url
        self.title = portalItem.title
        self.snippet = portalItem.snippet
        self.id = portalItem.id?.rawValue ?? UUID().uuidString
        self.model = model
    }
    
    init(id: String? = nil, thumbnailUrl: URL?, title: String?, snippet: String?) {
        self.thumbnailUrl = thumbnailUrl
        self.title = title
        self.snippet = snippet
        self.id = id ?? UUID().uuidString
    }
    
    static func previewData() -> MapItem {
        return MapItem(thumbnailUrl: URL(string: "https://www.arcgis.com/sharing/rest/content/items/ 3bc3179f17da44a0acObfdac4ad15664/info/ thumbnail/ago_downloaded.png")!,
                            title: "Bonston Circle",
                            snippet: "It lies on Massachusetts Bay, an arm of the Atlantic Ocean. The city proper has an unusually small area for a major city")
    }
    
    func loadMap() async -> Map? {
        portalItem != nil ? Map(item: portalItem!) : nil
    }
}

class OnlineMap: MapItem {
    
    init(portalItem: PortalItem) {
        super.init(portalItem: portalItem)
    }
}

