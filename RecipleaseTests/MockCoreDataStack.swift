//
//  MockCoreDataStack.swift
//  RecipleaseTests
//
//  Created by Kevin Bertrand on 03/06/2022.
//

import Reciplease
import CoreData
import Foundation


final class MockCoreDataStack: CoreDataStack {
    override init() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: CoreDataStack.persistentContainerName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        CoreDataStack.persistentContainer = container
    }
}
