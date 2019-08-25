//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol RecipeRepository {
    func getRecipes(ingredients: String, callback: @escaping (Result<[Recipe], Error>) -> Void)
}

class RecipeRepositoryImplementation: RecipeRepository {
    
    //MARK: - Methods
    
    func getRecipes(ingredients: String, callback: @escaping (Result<[Recipe], Error>) -> Void) {
        NetworkingImplementation.shared.request(ingredients: ingredients) { (result) in
            switch result {
            case .success(let data):
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    DispatchQueue.main.async {
                        callback(.success(searchResult.hits.map { $0.recipe }))
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


