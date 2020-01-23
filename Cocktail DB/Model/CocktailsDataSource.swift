//
//  CocktailsDataSource.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 16.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit


protocol CocktailsDataSourceDelegate {
    func loadAllCategory()
}


class CocktailsDataSource {
    
    private var networkClient = NetworkClient()
    private let cocktailsVC = CocktailsViewController()
    
    var delegate: CocktailsDataSourceDelegate?
    
    init(delegate: CocktailsDataSourceDelegate) {
       self.delegate = delegate
    }
    
    static var dataIsLoaden = false
    static var filterIsLoaden = false
    private var categories: [String] = []
    var myDrinks: [String: [Cocktail]] = [:]
    private var allCocktails: [String: [[String: String]]] = [:]
    private var drinks: [String: [[String: String]]] = [:]
    private var selectedCategoryName: String?
        
    var loadenData = false {
        willSet{
            if newValue {
                CocktailsDataSource.dataIsLoaden = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
            }}
    }
    
    
    func getCategories() -> [String] {
        let category = Array(drinks.keys)
        return category
    }
    
    func getSelectedCategoryName() -> String? {
        return selectedCategoryName
    }
    
    
    func displayWarningLable(text: String, vc: UIViewController) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func getCategoryCocktailsFromNetwork() {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list") else {return}
        
        networkClient.execute(url) { (json, error) in
            if let error = error {
                print("Error on 'getCategoryCocktailsFromNetwork': \(error.localizedDescription)")
            } else if let json = json {
                let cocktailsCategoryDictionary = json["drinks"]
                for value in cocktailsCategoryDictionary! {
                    let category = value["strCategory"]!
                    self.categories.append(category)
                    self.getAllCocktailsFromNetwork(for: category)
                }
            }
        }
    }
    
    
    func getAllCocktailsFromNetwork(for category: String) {
        let changedCategoryText = category.replacingOccurrences(of: " ", with: "_") as NSString
        
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(changedCategoryText)") else {return}
        
        networkClient.execute(url) { (json, error) in
            if let error = error {
                print("Error on 'getAllCocktailsFromNetwork': \(error.localizedDescription)")
            } else if let json = json {
                let cocktailsDictionary = json["drinks"]
                self.allCocktails[category] = cocktailsDictionary!
                self.drinks[category] = cocktailsDictionary!
                self.loadenData = true
                self.loadenData = false                
            }
        }
    }
    
    
    //MARK - Cocktails Table Info
    
    func numberOfSections() -> Int {
        return drinks.count
    }
    
    func categoryForSection(_ section: Int) -> String {
        let category = Array(drinks.keys)
        return category[section]
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        guard drinks.count > section else { return 0 }
        let valueArray = Array(drinks.values)
        return valueArray[section].count
    }
    
    func drinkForIndexPath(indexPath: IndexPath) -> [String : String] {
        guard drinks.count > indexPath.section else { return ["":""]}
        let valueArray = Array(drinks.values)
        return valueArray[indexPath.section][indexPath.row]
    }
    
    func setCategoriesToFilter(from categoriesNames: String) {
        if categoriesNames.isEmpty {
            drinks = allCocktails
            selectedCategoryName = nil
        } else {
            selectedCategoryName = categoriesNames
            drinks = [categoriesNames: allCocktails[categoriesNames]!]
            CocktailsDataSource.filterIsLoaden = true
        }
        
    }
    
}
