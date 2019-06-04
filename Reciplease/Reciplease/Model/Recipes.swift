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
    var recipes: [Recipe] = []
}

struct Recipes: Decodable {
    let hits: [Recipe]
    
}

struct Recipe: Decodable {
    let label: String
    let image: Data
    let ingredientsLines: [String]
}
