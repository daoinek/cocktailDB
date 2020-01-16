//
//  CocktailsDataSource.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 16.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit

var selectedCategoryArray: [String: [[String: String]]]?
var selectedCategoryIndex: Int?


class CocktailsDataSource {
    
    static let sharedInstance = CocktailsDataSource()

    
    private var networkClient = NetworkClient()
    private let cocktailsVC = CocktailsViewController()
    private var categories = Array<String>()
//    var selectedCategoryArray: SelectedCategoryArray = .init(selectedCategoryArray: [:])
    var allCoctails: [String: [[String: String]]] = [:]
    private var isFiltered: Bool = false {
        didSet{

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedCategory"), object: nil)
            }
    }
    private var backFromFilter = false
    private var isLoadenData: Bool = false {
        willSet{
            if newValue {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            }}
    }
    
    
        
    func dataIsLoaden() -> Bool {
        return isLoadenData
    }
    
    
    func getSelectedCategoryIndex() -> Int? {
        return selectedCategoryIndex
    }
    
    func backFromFilterWithoutChanges(status: Bool) {
        backFromFilter = status
    }
    
    func getAllCoctailsArray() -> [String: [[String: String]]] {
        return allCoctails
    }
    
    
    func displayWarningLable(text: String, vc: UIViewController) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func selectCategory(forIndex index: Int, allCoctails: [String: [[String: String]]]) {
        selectedCategoryIndex = index
        let allCategory = Array(allCoctails.keys)
        let category = allCategory[index]
        let array = allCoctails[category]
        selectedCategoryArray = [category: array!]
        print("myselectedCategoryArray: \(selectedCategoryArray)")
        
        isFiltered = true
    }
    
    func backFromFilterStatus() -> Bool {
        if backFromFilter == true {
            backFromFilter = false
            return true
        }
        return false
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
                self.allCoctails[category] = cocktailsDictionary!
                self.isLoadenData = true
                self.isLoadenData = false
            }
        }
    }
    
    
}
