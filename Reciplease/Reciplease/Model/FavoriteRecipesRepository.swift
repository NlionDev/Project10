//
//  FavoriteRecipesRepository.swift
//  Reciplease
//
//  Created by Nicolas Lion on 01/07/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol FavoriteRecipesRepository {
    func getFavoriteRecipes() -> [FavoriteRecipe]
    func getFavoriteRecipe(by uri: String) -> FavoriteRecipe?
    func addRecipeToFavorite(totalTime: Int, image: String, label: String, ingredientLines: [String], uri: String)
    func removeRecipe(by uri: String)
}

class FavoriteRecipesRepositoryImplementation: FavoriteRecipesRepository {
    
    func getFavoriteRecipes() -> [FavoriteRecipe] {
        var favorites: [FavoriteRecipe] = []
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        do {
            let favoritesRecipes = try PersistenceService.context.fetch(fetchRequest)
            favorites = favoritesRecipes
        } catch {
            
        }
        return favorites
    }
    
    func getFavoriteRecipe(by uri: String) -> FavoriteRecipe? {
        var favorites: [FavoriteRecipe] = []
        var favoriteRecipe: FavoriteRecipe?
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        do {
            let favoritesRecipes = try PersistenceService.context.fetch(fetchRequest)
            favorites = favoritesRecipes
            for recipe in favorites {
                if recipe.uri == uri {
                    favoriteRecipe = recipe
                }
            }
        } catch {
            
        }
        return favoriteRecipe
    }
    
    func addRecipeToFavorite(totalTime: Int, image: String, label: String, ingredientLines: [String], uri: String) {
        let favoriteRecipe = FavoriteRecipe(context: PersistenceService.context)
        favoriteRecipe.totalTime = totalTime
        favoriteRecipe.image = image
        favoriteRecipe.label = label
        favoriteRecipe.ingredientLines = ingredientLines
        favoriteRecipe.uri = uri
        PersistenceService.saveContext()
    }

    
    
    func removeRecipe(by uri: String) {
        var favorites: [FavoriteRecipe] = []
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        do {
            let favoritesRecipes = try PersistenceService.context.fetch(fetchRequest)
            favorites = favoritesRecipes
            for recipe in favorites {
                if recipe.uri == uri {
                    PersistenceService.context.delete(recipe)
                    PersistenceService.saveContext()
                }
            }
        } catch {
            
        }
    }
}
