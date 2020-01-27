//
//  CocktailsModel.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 22.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import ObjectMapper

typealias Drinks = ItemsLIst<Drink>

class Drink: Mappable {
        
    var id: Int?
    var name: String?
    var imageUrl: String?
        
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["idDrink"]
        name <- map["strDrink"]
        imageUrl <- map["strDrinkThumb"]
    }
}

