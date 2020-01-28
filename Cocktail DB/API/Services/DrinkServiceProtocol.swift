//
//  DrinkServiceProtocol.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 27.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import RxSwift

protocol DrinkServiceProtocol {    
    @discardableResult func loadCategories() -> Observable<Categories>
    @discardableResult func loadDrinks(categoryName: String) -> Observable<Drinks>
}
