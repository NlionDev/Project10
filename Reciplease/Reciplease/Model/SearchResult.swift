//
//  Recipes.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let hits: [Recipes]
    
}

struct Recipes: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    let label: String
    let ingredientLines: [String]
    let totalTime: Int
    let image: String
}

