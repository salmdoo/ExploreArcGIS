//
//  Persistence.swift
//  testCD
//
//  Created by Salmdo on 11/8/23.
//

import CoreData
import SwiftUI
import OSLog

struct PersistenceController {
    static let instance = PersistenceController()

    private let fetchRequest: NSFetchRequest<MapOffline> = MapOffline.fetchRequest()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MapDataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func fetchAllMaps() -> Result<[OfflineStoredMap], Error> {
        let context = container.viewContext
        
        do {
            let results = try context.fetch(fetchRequest)
            return Result {
                results.compactMap { OfflineStoredMap(offlineModel: $0) }
            }
        } catch {
            return .failure(error)
        }
    }
    
     func saveMap(map: OfflineStoredMap){
         let context = container.viewContext
         let mapSaved = MapOffline(context: context)
         mapSaved.title = map.title
         mapSaved.id = map.portalItem?.id?.description
         mapSaved.snippet = map.snippet
         mapSaved.mapFile = map.mapURL
         mapSaved.thumbnailUrl = map.thumbnailUrl
         
         print(map.title)
         do {
             try context.save()
         } catch {
             print("PersistenceController - save() - Cannot save meal with meal id \(mapSaved.id!)")
         }
    }
}
