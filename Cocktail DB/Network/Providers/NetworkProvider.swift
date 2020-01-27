//
//  Model.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 11.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import Moya


protocol NetworkProvider {}

extension NetworkProvider {
    
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
