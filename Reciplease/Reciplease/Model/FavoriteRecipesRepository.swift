//
//  FavoriteRecipesRepository.swift
//  Reciplease
//
//  Created by Nicolas Lion on 01/07/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import CoreData

protocol FavoriteRecipesRepository {
    func getFavoriteRecipes() -> [FavoriteRecipe]
    func addRecipeToFavoriteFromDetails(recipe: Recipe)
    func addRecipeToFavoriteFromFavorite(recipe: FavoriteRecipe)
    func removeRecipeOfFavorites(recipe: FavoriteRecipe)
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
    
    func addRecipeToFavoriteFromDetails(recipe: Recipe) {
        let favoriteRecipe = FavoriteRecipe(context: PersistenceService.context)
        favoriteRecipe.totalTime = recipe.totalTime
        favoriteRecipe.image = recipe.image
        favoriteRecipe.label = recipe.label
        favoriteRecipe.ingredientLines = recipe.ingredientLines
        PersistenceService.saveContext()
    }
    
    func addRecipeToFavoriteFromFavorite(recipe: FavoriteRecipe) {
        let favoriteRecipe = FavoriteRecipe(context: PersistenceService.context)
        favoriteRecipe.totalTime = recipe.totalTime
        favoriteRecipe.image = recipe.image
        favoriteRecipe.label = recipe.label
        favoriteRecipe.ingredientLines = recipe.ingredientLines
        PersistenceService.saveContext()
    }
    
    
    func removeRecipeOfFavorites(recipe: FavoriteRecipe) {
        PersistenceService.context.delete(recipe)
        PersistenceService.saveContext()
    }
}
