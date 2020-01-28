//
//  CocktailsDataSource.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 16.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit
import Moya
import RxSwift


class DrinksDataSource {
    
    // MARK: - Properties
    
    var delegate: DrinksDataSourceDelegate?
    
    private var networkClient = DrinkService()
    private let disposeBag = DisposeBag()
    private let drinksVC = DrinksViewController()
    private var allCategories = [Category]()
    private var categories = [Category]()
    private var allCocktails = [[Drink]]()    
    
    // MARK: - Initialization
    
    init(delegate: DrinksDataSourceDelegate) {
       self.delegate = delegate
    }

    func getCategoryCocktailsFromNetwork() {
        networkClient.loadCategories().subscribe(onNext: { [weak self] (response) in
            self?.categoriesDidLoad(response: response)
        }).disposed(by: disposeBag)
    }
    
    func loadDrinksByCategories(_ categories: [Category]) {
        var categoriesForLoad = categories
        guard !categoriesForLoad.isEmpty else { return }
        guard let category = categoriesForLoad.first else { return}
        
        networkClient.loadDrinks(categoryName: category.name ?? "").subscribe(onNext: { [weak self] (response) in
            categoriesForLoad.removeFirst()
            self?.drinksDidLoad(сategory: category, responce: response)
            self?.loadDrinksByCategories(categoriesForLoad)
        }).disposed(by: disposeBag)
    }
    
    
    //MARK: -  Did load dataFromNetwork methods
    
    private func drinksDidLoad(сategory: Category, responce: Drinks) {
        guard let section = categories.firstIndex(of: сategory),
        let drinksForSection = responce.list else { return }
        allCocktails.append(drinksForSection)
        delegate?.didLoadDrinksForSection(section: section)
    }
    
    private func categoriesDidLoad(response: Categories) {
        categories.removeAll()
        guard let categoriesFromServes = response.list else { return }
        allCategories = categoriesFromServes
        categories = categoriesFromServes
        delegate?.didLoadCategories()
    }
    
    private func drinksDidLoadForCategory(сategory: Category, responce: Drinks) {
        guard let section = categories.firstIndex(of: сategory),
        let drinksForSection = responce.list else { return }        
        allCocktails.append(drinksForSection)
        delegate?.didLoadDrinksForSection(section: section)
    }
    
    //MARK - Drinks Table Info
    
    func numberOfSections() -> Int {
        return categories.count
    }
    
    func categoryForSection(_ section: Int) -> Category {
        return categories[section]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        guard allCocktails.count > section else { return 0 }        
        return allCocktails[section].count
    }
    
    func drinkForIndexPath(indexPath: IndexPath) -> Drink {
        guard allCocktails.count > indexPath.section, allCocktails[indexPath.section].count > indexPath.row else { return Drink()}
        return allCocktails[indexPath.section][indexPath.row]
    }
    
    func getCategoriesNames() -> [String] {
        return categories.compactMap { $0.name }
    }
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func setCategoriesToFilter(from categoriesNames: [String]) {
        if categoriesNames.isEmpty {
            categories = allCategories
        } else {
            categories = allCategories.filter { categoriesNames.contains($0.name ?? "") }
        }
        
        allCocktails.removeAll()
        delegate?.willLoadDrinks()
        loadDrinksByCategories(categories)
    }
    
}
