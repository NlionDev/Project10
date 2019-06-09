//
//  Recipes.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation


class DownloadedRecipes {
    
    static let shared = DownloadedRecipes()
    init() {}
    
    var recipes: [Recipes] = []
}

struct SearchResult: Decodable {
    let hits: [Recipes]
    
}

struct Recipes: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    let label: String
    let ingredientLines: [String]
}

