//
//  MockContainer.swift
//  RecipleaseTests
//
//  Created by Nicolas Lion on 08/09/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit
import CoreData
@testable import Reciplease

class MockPersistenceService {
    
    private init() {}
    
    static var context: NSManagedObjectContext {
        return mockPersistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    static var mockPersistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "RecipleaseTests")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = mockPersistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

