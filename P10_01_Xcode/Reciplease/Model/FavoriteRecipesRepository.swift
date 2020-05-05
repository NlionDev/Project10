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
    func getFavoriteRecipes() throws -> [FavoriteRecipe]
    func getFavoriteRecipe(by uri: String) throws-> FavoriteRecipe?
    func addRecipeToFavorite(totalTime: Int, image: String, label: String, ingredientLines: [String], uri: String, url: String)
    func removeRecipe(by uri: String) throws
}

enum FavoriteRecipeRequestError: Error {
    case requestForFavoriteRecipesError
    case requestForGettingRecipeByUriError
    case removingRecipeError
    
}

class FavoriteRecipesRepositoryImplementation: FavoriteRecipesRepository {
    
    let persistentContainer: NSPersistentContainer
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        self.init(container: PersistenceService.persistentContainer)
    }
    
    func getFavoriteRecipes() throws -> [FavoriteRecipe] {
        var favorites: [FavoriteRecipe] = []
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        do {
            let favoritesRecipes = try persistentContainer.viewContext.fetch(fetchRequest)
            favorites = favoritesRecipes
        } catch {
            
            throw FavoriteRecipeRequestError.requestForFavoriteRecipesError
        }
        
        return favorites
    }
    
    func getFavoriteRecipe(by uri: String) throws -> FavoriteRecipe? {
        var favoriteRecipe: FavoriteRecipe?
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        do {
            let favoritesRecipes = try persistentContainer.viewContext.fetch(fetchRequest)
            favoriteRecipe = favoritesRecipes.first { favoriteRecipe -> Bool in
                favoriteRecipe.uri == uri
            }
        } catch {
            throw FavoriteRecipeRequestError.requestForGettingRecipeByUriError
        }
        
        return favoriteRecipe
        
    }
    
    func addRecipeToFavorite(totalTime: Int, image: String, label: String, ingredientLines: [String], uri: String, url: String) {
        let favoriteRecipe = FavoriteRecipe(context: persistentContainer.viewContext)
        favoriteRecipe.totalTime = totalTime
        favoriteRecipe.image = image
        favoriteRecipe.label = label
        favoriteRecipe.ingredientLines = ingredientLines
        favoriteRecipe.uri = uri
        favoriteRecipe.url = url
        PersistenceService.saveContext()
    }

    func removeRecipe(by uri: String) throws {
        var favorites: [FavoriteRecipe] = []
        let fetchRequest: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        do {
            let favoritesRecipes = try persistentContainer.viewContext.fetch(fetchRequest)
            favorites = favoritesRecipes
            for recipe in favorites {
                if recipe.uri == uri {
                    persistentContainer.viewContext.delete(recipe)
                    try backgroundContext.save()
                }
            }
        } catch {
            throw FavoriteRecipeRequestError.removingRecipeError
        }
        
    }
}
