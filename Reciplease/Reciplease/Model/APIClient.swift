//
//  APIClient.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation

class APIClient {
    
    init(session: URLSession) {
        self.session = session
    }
    
    //MARK: - Properties
    
    var session = URLSession(configuration: .default)
    
    var url = URL(string: "https://api.edamam.com/search?q=\(ingredients)&app_id=\(appId)&app_key=\(appKey)")
    static let appId = "364d7474"
    static let appKey = "2345daf55ba67a7ddb05aa2b537d97da"
    static var ingredients = Ingredients.shared.ingredients.joined(separator: ",")
    
    //MARK: - Methods
    
    func request(completion: @escaping (Result<Data, Error>) -> Void) {
        if let urlRequest = url {
            var request = URLRequest(url: urlRequest)
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    completion(.success(data))
                    
                }
                if let error = error {
                    completion(.failure(error))
                    
                    return
                }
            }
            
            task.resume()
        }
    }
}
    

