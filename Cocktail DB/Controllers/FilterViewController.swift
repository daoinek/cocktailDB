//
//  FilterViewController.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 11.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyFiltersButton: UIButton!

    private var selectedIndex: Int?
    var allCocktails: [String: [[String: String]]]?
    let cocktailsViewController = CocktailsViewController()
    let cocktailsDataSource = CocktailsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadDesign()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(FilterViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        cocktailsDataSource.backFromFilterWithoutChanges(status: true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyFilters(_ sender: UIButton) {
        guard let selectedIndex = selectedIndex else { return }
        cocktailsDataSource.selectCategory(forIndex: selectedIndex, allCoctails: allCocktails!)
            navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let valueArray = Array(allCocktails!.keys)
        print(valueArray)
        return valueArray.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "categoryInFilter", for: indexPath)
        
        let valueArray = Array(allCocktails!.keys)
        cell.textLabel?.text = valueArray[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        if selectedIndex == cocktailsDataSource.getSelectedCategoryIndex() {
            applyFiltersButton.isEnabled = false
        } else { applyFiltersButton.isEnabled = true}
    }
    

}

extension FilterViewController {
    
    func loadDesign() {
    tableView.tableFooterView = UIView()
    applyFiltersButton.layer.borderWidth = 1
    applyFiltersButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    applyFiltersButton.layer.cornerRadius = 15
    applyFiltersButton.layer.masksToBounds = true
    }
}
