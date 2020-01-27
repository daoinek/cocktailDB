//
//  FilterViewController.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 11.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit

public protocol FiltersViewControllerDelegate {
    func filtersDidChange(filters: String)
    func backFromFilter()
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var delegate: FiltersViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyFiltersButton: UIButton!

    static var allCocktailsCategory = [String]()
    static var selectedCategoryNameFromTable: String?
    private var currentSelectedFilter = ""
    
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
    
    static func createVC(with category: [String], delegate: FiltersViewControllerDelegate, selectedCategory: String?) -> FilterViewController {
        let vc = UIStoryboard(name: "FilterViewController", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        
        if FilterViewController.allCocktailsCategory.isEmpty {
            FilterViewController.allCocktailsCategory = category
        }
        
        if selectedCategory != nil { FilterViewController.selectedCategoryNameFromTable = selectedCategory!}
        vc.delegate = delegate
        
        return vc
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        delegate!.backFromFilter()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyFilters(_ sender: UIButton) {
        delegate!.filtersDidChange(filters: currentSelectedFilter)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return FilterViewController.allCocktailsCategory.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "categoryInFilter", for: indexPath)
        
        cell.textLabel?.text = FilterViewController.allCocktailsCategory[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        
        currentSelectedFilter = FilterViewController.allCocktailsCategory[selectedIndex]
        
        guard let select = FilterViewController.selectedCategoryNameFromTable else { return }
        
        if FilterViewController.allCocktailsCategory[indexPath.row] == select
        {applyFiltersButton.isEnabled = false } else {applyFiltersButton.isEnabled = true}
        
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
