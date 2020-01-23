//
//  Model.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 11.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import Foundation
import Alamofire


struct Category: Decodable {
    let drinks: [DrinksCategory]
}

struct DrinksCategory: Decodable {
     let strCategory: String
}

class NetworkClient {
    
    typealias WebResponse = ([String: [[String: String]]]?, Error?) -> Void
    
    func execute(_ url: URL, completion: @escaping WebResponse) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        Alamofire.request(urlRequest)
        
        Alamofire.request(url).validate().responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            } else if let categoryListArray = response.result.value as? [String: [[String: String]]] {
                completion(categoryListArray, nil)
            } else if let cocktailListArray = response.result.value as? [String: [[String: String]]] {
                completion(cocktailListArray, nil)
            }
        }
    }
}
