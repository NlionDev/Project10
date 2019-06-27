//
//  FavoritesRecipes.swift
//  Reciplease
//
//  Created by Nicolas Lion on 26/06/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import CoreData

class FavoritesRecipes {
    
    init() {}
    
    static let shared = FavoritesRecipes()
    var favoritesRecipes: [FavoriteRecipe] = []
    var favoritesRecipesNames: [String] = []
    
}
