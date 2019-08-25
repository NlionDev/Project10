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
    
    static let shared = MockNetworking()
    
    init() {}
    
    var error: Error? {
        return RecipeError()
    }
    
    var recipeCorrectData: Data? {
        let bundle = Bundle(for: MockNetworking.self)
        let url = bundle.url(forResource: "Recipes", withExtension:
            "json")!
        return try! Data(contentsOf: url)
    }
    
    var recipeIncorrectData: Data? {
        return "erreur".data(using: .utf8)!
    }
    
    
    func request(ingredients: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        
        if let data = recipeCorrectData {
            completion(.success(data))
        }
        
        
        if let error = error {
            completion(.failure(error))
        }
    }
    
}


class RecipeError: Error {}
