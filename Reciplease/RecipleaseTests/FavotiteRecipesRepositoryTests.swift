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

class FavoriteRecipesRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    let favoriteRecipeRepository = FavoriteRecipesRepositoryImplementation()
    var favoriteRecipes: [FavoriteRecipe] = []
    var favoriteRecipe: FavoriteRecipe!
    
    // MARK: - Lifecycle

    override func setUp() {
        do {
            favoriteRecipes = try favoriteRecipeRepository.getFavoriteRecipes()
        }
        catch {}
    }
    
    override func tearDown() {
        do {
            for recipe in favoriteRecipes {
                if let uri = recipe.uri {
                    try favoriteRecipeRepository.removeRecipe(by: uri)
                }
            }
        }
        catch {}
    }
    
    // MARK: - Tests
    
    func testRecipeShouldBeSavedInCoreData() {
        // Given
        tearDown()
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
