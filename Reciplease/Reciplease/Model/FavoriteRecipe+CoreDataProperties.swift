//
//  FavoriteRecipe+CoreDataProperties.swift
//  Reciplease
//
//  Created by Nicolas Lion on 26/06/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRecipe> {
        return NSFetchRequest<FavoriteRecipe>(entityName: "FavoriteRecipe")
    }

    @NSManaged public var name: String?
    @NSManaged public var cookingTime: Int16
    @NSManaged public var imageURLString: String?
    @NSManaged public var ingredients: [String]?

}
