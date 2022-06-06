//
//  CoreDataStackTest.swift
//  RecipleaseTests
//
//  Created by Kevin Bertrand on 02/06/2022.
//

@testable import Reciplease
import CoreData

struct CoreDataStackTest {
    let persistentContainer: NSPersistentContainer
    var mainContext: NSManagedObjectContext
    //    {
    //        return persistentContainer.viewContext
    //    }
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Reciplease")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        //        description?.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("Was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
    
    private let persistentContainerName = "Reciplease"
    //    private lazy var persistentContainer: NSPersistentContainer = {
    //        let container = NSPersistentContainer(name: persistentContainerName)
    //        container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
    //
    //        container.loadPersistentStores { storeDescription, error in
    //            if let error = error as NSError? {
    //                fatalError("Unresolved error \(error), \(error.userInfo) for: \(storeDescription.description)")
    //            }
    //        }
    //        return container
    //    }()
    
    lazy var persistent: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: persistentContainerName)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
