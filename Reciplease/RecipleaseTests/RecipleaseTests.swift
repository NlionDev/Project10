//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import XCTest
@testable import Reciplease
import CoreData

class RecipleaseTests: XCTestCase {
    
    // MARK: - Properties
    
    let ingredientRepository = IngredientsRepositoryImplementation()
    let favoriteRecipeRepository = FavoriteRecipesRepositoryImplementation()
    var ingredients: [Ingredient] = []
    var ingredientsNames: [String] = []
    var favoriteRecipes: [FavoriteRecipe] = []
    var favoriteRecipe: FavoriteRecipe!
    
    // MARK: - Lifecycle

    override func setUp() {
        do {
            ingredients = try ingredientRepository.makeFetchRequestForIngredients()
        }
        catch {}
        
        do {
            favoriteRecipes = try favoriteRecipeRepository.getFavoriteRecipes()
        }
        catch {}
        
        do {
            ingredientsNames = try ingredientRepository.makeFetchRequestForNames()
        }
        catch {}
        
        for ingredient in ingredients {
            ingredientRepository.removeIngredient(ingredient: ingredient)
        }
        
        
        do {
            for recipe in favoriteRecipes {
                if let uri = recipe.uri {
                    try favoriteRecipeRepository.removeRecipe(by: uri)
                }
            }
        }
        catch {}

    }
    
    override func tearDown() {
        
    }
    
    // MARK: - Tests
    
    func testRecipeDownloadShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let recipeRepository = RecipeRepositoryImplementation(networking: MockNetworking.shared)
        
        // When
        let expectation = self.expectation(description: "Wait for Callback")
        recipeRepository.getRecipes(ingredients: "Chicken") { (result) in
            //Then
            if case .success(let searchResult) = result {
                XCTAssertNotNil(searchResult)
                if let recipe = searchResult.first {
                    let label = recipe.label
                    let image = recipe.image
                    let uri = recipe.uri
                    let ingredientLines = recipe.ingredientLines
                    let time = recipe.totalTime
                    XCTAssertEqual(label, "Chicken Vesuvio")
                    XCTAssertEqual(image, "https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg")
                    XCTAssertEqual(uri, "http://www.edamam.com/ontologies/edamam.owl#recipe_b79327d05b8e5b838ad6cfd9576b30b6")
                    XCTAssertEqual(ingredientLines, [
                        "1/2 cup olive oil",
                        "5 cloves garlic, peeled",
                        "2 large russet potatoes, peeled and cut into chunks",
                        "1 3-4 pound chicken, cut into 8 pieces (or 3 pound chicken legs)",
                        "3/4 cup white wine",
                        "3/4 cup chicken stock",
                        "3 tablespoons chopped parsley",
                        "1 tablespoon dried oregano",
                        "Salt and pepper",
                        "1 cup frozen peas, thawed"
                        ])
                    XCTAssertEqual(time, 60)
                    expectation.fulfill()
                }
            }
        }
        waitForExpectations(timeout: 0.1)
    }
    
    func testRecipeDownloadShouldPostFailedCallbackIfError() {
        // Given
        let recipeRepository = RecipeRepositoryImplementation(networking: MockNetworking.shared)
        
        // When
        let expectation = self.expectation(description: "Wait for Failure.")
        recipeRepository.getRecipes(ingredients: "Chicken") { (result) in
            // Then
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1)
    }
    
    
    func testChickenIngredientShouldBeSavedInCoreData() {
        // Given
        let ingredient = "Chicken"
        
        // When
        ingredientRepository.saveIngredient(name: ingredient)
        XCTAssertNoThrow(ingredients = try ingredientRepository.makeFetchRequestForIngredients())
        
        // Then
        if let ingredientName = ingredients.first?.name {
        XCTAssertEqual(ingredientName, "Chicken")
        }
    }
    
    func testChickenIngredientShouldBeRemovedFromCoreData() {
        // Given
//        let ingredient = "Chicken"
//        ingredientRepository.saveIngredient(name: ingredient)
        
        // When
        if let ingredient = ingredients.first {
        ingredientRepository.removeIngredient(ingredient: ingredient)
        }
         XCTAssertNoThrow(ingredients = try ingredientRepository.makeFetchRequestForIngredients())
        
        // Then
        XCTAssertEqual(ingredients, [])
    }
    
    func testGetIngredientsShouldBeSuccess() {
        // Given
        let ingredient = "Chicken"
        ingredientRepository.saveIngredient(name: ingredient)
        
        // When
        XCTAssertNoThrow(ingredients = try ingredientRepository.makeFetchRequestForIngredients())
        
        // Then
        if let name = ingredients.first?.name {
            XCTAssertEqual(name, "Chicken")
        }
    }
    
    func testGetIngredientsNamesShouldBeSuccess() {
        // Given
        let ingredient = "Chicken"
        ingredientRepository.saveIngredient(name: ingredient)
        
        // When
        XCTAssertNoThrow(ingredientsNames = try ingredientRepository.makeFetchRequestForNames())
        
        // Then
        if let name = ingredientsNames.first {
            XCTAssertEqual(name, "Chicken")
        }
    }
    
//    func testIngredientsDownloadShouldBeCatchAnError() {
//
//        XCTAssertThrowsError(try ingredientRepository.makeFetchRequestForIngredients()) { error in
//            XCTAssertNotNil(error as? IngredientRequestError)
//            XCTAssertEqual(error as! IngredientRequestError, IngredientRequestError.requestForIngredientsError)
//        }
//    }
//
//    func testIngredientsNamrsDownloadShouldBeCatchAnError() {
//
//        XCTAssertThrowsError(try ingredientRepository.makeFetchRequestForNames()) { error in
//            XCTAssertNotNil(error as? IngredientRequestError)
//            XCTAssertEqual(error as! IngredientRequestError, IngredientRequestError.requestForIngredientsNamesError)
//        }
//    }
    
    func testRecipeShouldBeSavedInCoreData() {
        // Given
        let name = "Chicken Potatoes"
        let uri = "id"
        let image = "image"
        let time = 60
        let ingredientLines = ["Chicken", "Potatoes"]
        
        // When
        favoriteRecipeRepository.addRecipeToFavorite(totalTime: time, image: image, label: name, ingredientLines: ingredientLines, uri: uri)
        XCTAssertNoThrow(favoriteRecipes = try favoriteRecipeRepository.getFavoriteRecipes() )
        
        // Then
        if let recipe = favoriteRecipes.first,
        let name = recipe.label,
        let uri = recipe.uri,
        let image = recipe.image,
        let ingredientLines = recipe.ingredientLines {
            XCTAssertEqual(name, "Chicken Potatoes")
            XCTAssertEqual(uri, "id")
            XCTAssertEqual(image, "image")
            XCTAssertEqual(ingredientLines, ["Chicken", "Potatoes"])
        }
    }
    
    
    func testARecipeShouldBeRemovedFromCoreData() {
        // Given
        let recipeUri = "id"
        
        // When
        XCTAssertNoThrow(try favoriteRecipeRepository.removeRecipe(by: recipeUri))
        XCTAssertNoThrow(favoriteRecipes = try favoriteRecipeRepository.getFavoriteRecipes())
        
        // Then
        XCTAssertEqual(favoriteRecipes, [])
    }
    
    func testGetRecipeByUriShouldBeSuccess() {
        // Given
        let recipeUri = "id"
        favoriteRecipeRepository.addRecipeToFavorite(totalTime: 60, image: "image", label: "name", ingredientLines: ["ingredient", "ingredient"], uri: recipeUri)
        
        // When
        XCTAssertNoThrow(favoriteRecipe = try favoriteRecipeRepository.getFavoriteRecipe(by: recipeUri))
        
        // Then
        if let favoriteRecipeUri = favoriteRecipe.uri {
            XCTAssertEqual(favoriteRecipeUri, recipeUri)
        }
    }
   
//    func testFavoriteRecipesDownloadShouldBeCatchAnError() {
//
//        XCTAssertThrowsError(try favoriteRecipeRepository.getFavoriteRecipes()) { error in
//            XCTAssertNotNil(error as? FavoriteRecipeRequestError)
//            XCTAssertEqual(error as! FavoriteRecipeRequestError, FavoriteRecipeRequestError.requestForFavoriteRecipesError)
//        }
//    }
//
//    func testFavoriteRecipesDownloadByUriShouldBeCatchAnError() {
//        let recipeUri = "id"
//
//        XCTAssertThrowsError(try favoriteRecipeRepository.getFavoriteRecipe(by: recipeUri)) { error in
//            XCTAssertNotNil(error as? FavoriteRecipeRequestError)
//            XCTAssertEqual(error as! FavoriteRecipeRequestError, FavoriteRecipeRequestError.requestForGettingRecipeByUriError)
//        }
//    }
   
}
