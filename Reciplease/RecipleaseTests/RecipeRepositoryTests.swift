//
//  RecipeRepositoryTests.swift
//  RecipleaseTests
//
//  Created by Nicolas Lion on 08/09/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import XCTest
@testable import Reciplease

class RecipeRepositoryTests: XCTestCase {
    
    
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
}
