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
    func getRecipes(ingredients: String, callback: @escaping (Result<SearchResult, Error>) -> Void)
    func recipesRequest(ingredients: String, completion: @escaping (Result<Data, Error>) -> Void)
    func imagesRequest(url: String, completion: @escaping (Result<Data, Error>) -> Void)
    func getImages(url: String, callback: @escaping (Result<UIImage, Error>) -> Void)
}

class RecipeRepositoryImplementation: RecipeRepository {
    
    //MARK: - Properties
    
    private let appId = "364d7474"
    private let appKey = "2345daf55ba67a7ddb05aa2b537d97da"
    
    //MARK: - Methods
    
    func recipesRequest(ingredients: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = URL(string: "https://api.edamam.com/search?q=\(ingredients)&app_id=\(appId)&app_key=\(appKey)")
        
        if let urlRequest = url {
            AF.request(urlRequest).responseJSON { (response) in
                if let data = response.data {
                    completion(.success(data))
                    
                }
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
            }
        }
    }

    
    func getRecipes(ingredients: String, callback: @escaping (Result<SearchResult, Error>) -> Void) {
        recipesRequest(ingredients: ingredients) { (result) in
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
    
    func imagesRequest(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        if let urlRequest = URL(string: url) {
            
            AF.request(urlRequest).responseImage { (response) in
                
                if let data = response.data {
                    completion(.success(data))
                    
                }
                if let error = response.error {

                    completion(.failure(error))
                    return
                }
            }
        }
    }

    func getImages(url: String, callback: @escaping (Result<UIImage, Error>) -> Void) {
        
        imagesRequest(url: url) { (result) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        callback(.success(image))
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

