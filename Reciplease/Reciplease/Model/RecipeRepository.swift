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
    func getRecipes(ingredients: String, completion: @escaping (Result<Recipe, Error>) -> Void)
}

class RecipeRepositoryImplementation: RecipeRepository {
    
    //MARK: - Properties
    
    private let appId = "364d7474"
    private let appKey = "2345daf55ba67a7ddb05aa2b537d97da"
    private let baseURL = "https://api.edamam.com/"
    
    //MARK: - Methods
    
    func getRecipes(ingredients: String, completion: @escaping (Result<Recipe, Error>) -> Void) {
        let searchPath = String.init(format: "search?q=%@&app_id=%@&app_key=%@","\(ingredients)", "\(appId)", "\(appKey)")
        let url = URL(string: "\(baseURL)\(searchPath)")
        
        guard let urlRequest = url else { return }
        
        AF.request(urlRequest).responseJSON { (response) in
            if let data = response.data {
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(searchResult.hits.map
                            { $0.recipe }))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    if let error = response.error {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}

