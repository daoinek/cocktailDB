//
//  CocktailService.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 27.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import Moya
import RxSwift
import Moya_ObjectMapper

protocol DrinkServiceProtocol {
    
    @discardableResult func loadCategories() -> Observable<Categories>
    @discardableResult func loadDrinks(categoryName: String) -> Observable<Drinks>
}


class CocktailService: DrinkServiceProtocol {
    
    private var drinkProvider = MoyaProvider<DrinkProvider>()
    
    @discardableResult func loadCategories() -> Observable<Categories> {
        return drinkProvider.rx.request(.listCategories).mapObject(Categories.self).asObservable()
    }
    
    @discardableResult func loadDrinks(categoryName: String) -> Observable<Drinks> {
        return drinkProvider.rx.request(.listDrinks(categoryName: categoryName)).mapObject(Drinks.self).asObservable()
    }
}
