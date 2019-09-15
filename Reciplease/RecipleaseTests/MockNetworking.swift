//
//  MockNetworking.swift
//  RecipleaseTests
//
//  Created by Nicolas Lion on 20/08/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import Alamofire
@testable import Reciplease

class MockNetworking: Networking {
    
    enum ExpectedResult {
        case correct
        case invalidJson
        case error
    }
    
    let expectedResult: ExpectedResult
    
    init (expectedResult: ExpectedResult) {
        self.expectedResult = expectedResult
    }
    
    var error: Error? {
        return RecipeError()
    }
    
    var recipeCorrectData: Data {
        let bundle = Bundle(for: MockNetworking.self)
        let url = bundle.url(forResource: "Recipes", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    var recipeIncorrectData = "erreur".data(using: .utf8)!
    
    
    func request(ingredients: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        switch expectedResult {
        case .correct:
            completion(.success(recipeCorrectData))
        case .invalidJson:
            completion(.success(recipeIncorrectData))
        case .error:
            completion(.failure(RecipeError()))
        }
    }
    
}


class RecipeError: Error {}
