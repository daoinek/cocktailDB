//
//  Category.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 16.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import Foundation

struct CategoriesDrink {
    var strCategory: String?
}


class CategoryDrink {
    var strCategory: String
    
    init(name: String) {
        self.strCategory = name
    }
}
