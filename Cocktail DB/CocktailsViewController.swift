//
//  CocktailsTableViewController.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 11.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

var categoryArray: [String] = []
var selectedCategoryIndex: Int?
var isFiltered = false
var backFromFilter = false
var selectedCategoryArray: [String: [[String: String]]]?
var allCoctails: [String: [[String: String]]] = [:]



class CocktailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    private var contentOffset: CGPoint?
    
    private var isLoadenData: Bool = false {
        willSet{
            if newValue {
                tableView.reloadData()
            }}
    }
    
    private let networkClient = NetworkClient()

    
    // MARK: - Outlets

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        tableView.tableFooterView = UIView()
        createSpinnerView()
        getCategoryCocktailsFromNetwork()

        let nib = UINib.init(nibName: "CocktailCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "customCell")
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        editTitleForNavigationItem()
        backFromFilterStatus()
        chechFilterStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.contentOffset = self.tableView.contentOffset
    }
    
    
    // MARK: - functions

    
    private func chechFilterStatus() {
        if isFiltered {
            filterButton.image = UIImage(named: "filter_on.png")
        } else {
            filterButton.image = UIImage(named: "filter_off.png")
        }
    }
    
    private func backFromFilterStatus() {
        if backFromFilter == true {
            if (self.contentOffset != nil) {
                self.tableView.setContentOffset(contentOffset!, animated: true)
            }
            backFromFilter = false
        }
    }
    
    private func editTitleForNavigationItem() {
        if selectedCategoryIndex != nil {
            let categoryTitle = categoryArray[selectedCategoryIndex!]
            navigationItem.title = categoryTitle
        } else { navigationItem.title = "Drinks"}
    }
    
    private func createSpinnerView() {
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.isLoadenData == true {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                timer.invalidate()
            }}
    }
    
    private func displayWarningLable (withText text: String) {
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    
    func backFromFilterWithoutChanges() {
        backFromFilter = true
    }
    
    
    @IBAction func openSearch(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "openFilter", sender: nil)
    }
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        if selectedCategoryIndex != nil {
            return 1
        }
            return allCoctails.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if selectedCategoryIndex != nil {
            if selectedCategoryArray != nil {
            let valueArray = Array(selectedCategoryArray!.values)
                return valueArray[0].count
            } else {
                displayWarningLable(withText: "Данные еще не загрузились")
                selectedCategoryIndex = nil
            }
        }
        
        let valueArray = Array(allCoctails.values)
        return valueArray[section].count
            
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCocktailCell

        if selectedCategoryIndex != nil {
            let valueArray = Array(selectedCategoryArray!.values)
            cell.cocktailName.text = valueArray[0][indexPath.row]["strDrink"]
            
            let url = URL(string: valueArray[0][indexPath.row]["strDrinkThumb"]!)!
            cell.cocktailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
        } else {
            let valueArray = Array(allCoctails.values)
            cell.cocktailName.text = valueArray[indexPath.section][indexPath.row]["strDrink"]
            
            let url = URL(string: valueArray[0][indexPath.row]["strDrinkThumb"]!)!
            cell.cocktailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)

        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if selectedCategoryIndex != nil {
            return nil
        } else {
            let category = Array(allCoctails.keys)            
            return category[section]
        }
    }


}

extension CocktailsViewController {
    
    private func getCategoryCocktailsFromNetwork() {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list") else {return}
        
        networkClient.execute(url) { (json, error) in
            if let error = error {
                print("Error on 'getCategoryCocktailsFromNetwork': \(error.localizedDescription)")
            } else if let json = json {
                let cocktailsCategoryDictionary = json["drinks"]
                for value in cocktailsCategoryDictionary! {
                    let category = value["strCategory"]!
                    categoryArray.append(category)
                    self.getAllCocktailsFromNetwork(for: category)
                }
            }
        }
    }
    
    
    private func getAllCocktailsFromNetwork(for category: String) {
        let changedCategoryText = category.replacingOccurrences(of: " ", with: "_") as NSString
        
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(changedCategoryText)") else {return}
        
        networkClient.execute(url) { (json, error) in
            if let error = error {
                print("Error on 'getAllCocktailsFromNetwork': \(error.localizedDescription)")
            } else if let json = json {
                let cocktailsDictionary = json["drinks"]
                allCoctails[category] = cocktailsDictionary!
                self.isLoadenData = true
            }
        }
    }
}
