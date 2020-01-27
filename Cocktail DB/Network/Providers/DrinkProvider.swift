//
//  DrinkProvider.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 27.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import Moya


enum DrinkProvider : NetworkProvider {
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
