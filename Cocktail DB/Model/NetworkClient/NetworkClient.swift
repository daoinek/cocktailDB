//
//  Model.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 11.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import Foundation
import Moya


protocol NetworkClient {}

extension NetworkClient {
    
    // MARK: - Properties
    
    var baseURL: URL {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/") else {
            fatalError("URL error")
        }
        return url
    }
    var path: String {
        return ""
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        return .requestPlain
    }
    var sampleData: Data {
        return "Not used?".data(using: .utf8)!
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    var authorizationType: AuthorizationType {
        return .basic
    }
}

enum DrinkProvider : NetworkClient {
    case listCategories
    case listDrinks(categoryName: String)
    
}

extension DrinkProvider : TargetType {
    
    var path: String {
        switch self {
        case .listCategories:
            return "list.php"
        case .listDrinks:
            return "filter.php"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .listCategories:
            let parameters = ["c": "list"]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .listDrinks(let categoryName):
            let parameters = ["c": categoryName]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
        
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
