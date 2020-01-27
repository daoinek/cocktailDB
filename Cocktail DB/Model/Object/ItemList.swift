//
//  ItemList.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 27.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import ObjectMapper

class ItemsLIst<T: Mappable>: NSObject, Mappable {
        
    var list: [T]?
        
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        list <- map["drinks"]
    }
}
