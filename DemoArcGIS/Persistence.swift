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
    
    func fetchAllMaps() throws -> [MapOffline]  {
        let context = container.viewContext
        return try context.fetch(fetchRequest)
        
//        do {
//            let results = try context.fetch(fetchRequest)
//            return Result {
//                results.compactMap { OfflineStoredMap(offlineModel: $0) }
//            }
//        } catch {
//            return .failure(error)
//        }
    }
    
     func saveMap(map: OfflineStoredMap) throws {
         let context = container.viewContext
         let mapSaved = MapOffline(context: context)
         mapSaved.title = map.title
         mapSaved.id = map.id
         mapSaved.snippet = map.snippet
         mapSaved.thumbnailUrl = map.thumbnailUrl
         
         try context.save()
    }
    
    func deleteMap(id: String) throws {
        let context = container.viewContext
        
        let fetchResult = try context.fetch(fetchRequest)
        
        for item in fetchResult {
            if let itemId = item.id, itemId == id {
                context.delete(item)
            }
        }
        
        if context.hasChanges {
            try context.save()
        }
                
    }
}
