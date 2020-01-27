//
//  Category.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 27.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import ObjectMapper

typealias Categories = ItemsLIst<Category>

class Category: NSObject, Mappable {
        
    // MARK: Properties

    var name: String?
        
    // MARK: Init

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        name <- map["strCategory"]
    }
}
