//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation

protocol RecipeRepository {
    func getRecipes(callback: @escaping (Result<SearchResult, Error>) -> Void)
}

class RecipeRepositoryImplementation: RecipeRepository {
    
    //MARK: - Properties
    
    private let apiClient = APIClient()
    
    //MARK: - Methods
    
    func getRecipes(callback: @escaping (Result<SearchResult, Error>) -> Void) {
        apiClient.request { (result) in
            switch result {
            case .success(let data):
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    DispatchQueue.main.async {
                        callback(.success(searchResult))
                        
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
