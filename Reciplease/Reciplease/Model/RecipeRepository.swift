//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation

protocol RecipeRepository {
    func getRecipes(callback: @escaping (Result<Recipes, Error>) -> Void)
}

class RecipeRepositoryImplementation: RecipeRepository {
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    //MARK: - Properties
    
    private var apiClient: APIClient
    
    //MARK: - Methods
    
    func getRecipes(callback: @escaping (Result<Recipes, Error>) -> Void) {
        apiClient.request { (result) in
            switch result {
            case .success(let data):
                do {
                    let recipes = try JSONDecoder().decode(Recipes.self, from: data)
                    DispatchQueue.main.async {
                        callback(.success(recipes))
                        
                    }
                } catch {
                    DispatchQueue.main.async {
                        callback(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
            }
        }
    }
}
