//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 31/05/2022.
//

import CoreData
import Foundation

final class CoreDataStack {
    // MARK: Public
    // MARK: Properties
    static let sharedInstance = CoreDataStack()
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }
    
    // MARK: Private
    // MARK: Initialization
    private init() {}
    
    // MARK: Properties
    private let persistentContainerName = "Reciplease"
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) for: \(storeDescription.description)")
            }
        }
        return container
    }()
}
