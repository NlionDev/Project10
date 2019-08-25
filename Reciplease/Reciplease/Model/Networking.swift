//
//  Networking.swift
//  Reciplease
//
//  Created by Nicolas Lion on 07/08/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

protocol Networking {
    func request(ingredients: String, completion: @escaping (Result<Data, Error>) -> Void)

}

class NetworkingImplementation: Networking {
    
    static let shared = NetworkingImplementation()
    
    init() {}
    
    // MARK: - Properties
    
    private let appId = "364d7474"
    private let appKey = "2345daf55ba67a7ddb05aa2b537d97da"
    private let baseURL = "https://api.edamam.com/"
    
    // MARK: - Methods
    
    func request(ingredients: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        let searchPath = String.init(format: "search?q=%@&app_id=%@&app_key=%@","\(ingredients)", "\(appId)", "\(appKey)")
        let url = URL(string: "\(baseURL)\(searchPath)")
        
        guard let urlRequest = url else { return }
        
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

    

