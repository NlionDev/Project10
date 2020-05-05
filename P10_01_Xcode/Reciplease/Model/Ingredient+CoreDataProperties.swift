//
//  Ingredient+CoreDataProperties.swift
//  Reciplease
//
//  Created by Nicolas Lion on 07/07/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?

}
