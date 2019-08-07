//
//  IngredientRepository.swift
//  Reciplease
//
//  Created by Nicolas Lion on 07/07/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import CoreData

protocol IngredientsRepository {
    func makeFetchRequestForNames() throws -> [String]
    func makeFetchRequestForIngredients() throws -> [Ingredient]
    func saveIngredient(name: String)
    func removeIngredient(ingredient: Ingredient)
}

enum IngredientRequestError: Error {
    case requestForIngredientsNamesError
    case requestForIngredientsError

}

class IngredientsRepositoryImplementation: IngredientsRepository {
    
    func makeFetchRequestForNames() throws -> [String] {
        var ingredients: [String] = []
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        do {
            let savedIngredients = try PersistenceService.context.fetch(fetchRequest)
            for ingredient in savedIngredients {
                if let ingredientName = ingredient.name {
                    ingredients.append(ingredientName)
                }
            }
        } catch {
            throw IngredientRequestError.requestForIngredientsNamesError
        }
        return ingredients
    }
    
    func makeFetchRequestForIngredients() throws -> [Ingredient] {
        var ingredients: [Ingredient] = []
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        do {
            let savedIngredients = try PersistenceService.context.fetch(fetchRequest)
            ingredients = savedIngredients
        } catch {
            throw IngredientRequestError.requestForIngredientsError
        }
        return ingredients
    }
    
    func saveIngredient(name: String) {
        let ingredient = Ingredient(context: PersistenceService.context)
        ingredient.name = name
        PersistenceService.saveContext()
    }
    
    func removeIngredient(ingredient: Ingredient) {
        PersistenceService.context.delete(ingredient)
        PersistenceService.saveContext()
    }

}
