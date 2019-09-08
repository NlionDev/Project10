//
//  IngredientsRepositoryTests.swift
//  RecipleaseTests
//
//  Created by Nicolas Lion on 08/09/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import XCTest
@testable import Reciplease
import CoreData

class IngredientsRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    var ingredients: [Ingredient] = []
    var ingredientsNames: [String] = []
    let ingredientRepository = IngredientsRepositoryImplementation()
    
    // MARK: - Lifecycle
    
    override func setUp() {
        do {
            ingredients = try ingredientRepository.makeFetchRequestForIngredients()
        }
        catch {}
        
        do {
            ingredientsNames = try ingredientRepository.makeFetchRequestForNames()
        }
        catch {}
    }
    
    override func tearDown() {
        for ingredient in ingredients {
            ingredientRepository.removeIngredient(ingredient: ingredient)
        }
    }
    
    // MARK: - Tests
    
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
    

}
