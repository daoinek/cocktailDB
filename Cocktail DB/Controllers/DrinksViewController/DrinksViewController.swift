//
//  CocktailsTableViewController.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 11.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD


protocol DrinksDataSourceDelegate {
    func loadAllCategory()
    func didLoadCategories()
    func didLoadDrinksForSection(section: Int)
    func willLoadDrinks()
}


class DrinksViewController: UIViewController, DrinksDataSourceDelegate {
    private lazy var dataSource = DrinksDataSource(delegate: self)
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
        
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        loadAllCategory()
        conectNib()
        tableView.tableFooterView = UIView()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    private func filterIsSelected(_ value: Bool) {
        guard let filterButtonItem = filterButton else { return }
        if value {
            filterButtonItem.image = UIImage(named: "filter_on.png")
        } else {
            filterButtonItem.image = UIImage(named: "filter_off.png")
        }
    }
    
    private func conectNib() {
        let cellNib = UINib.init(nibName: "DrinkCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "customCell")
    }
    
    @IBAction func openSearch(_ sender: UIBarButtonItem) {
        routeToFilters()
    }
    
    private func routeToFilters() {
        let filters = dataSource.getCategoriesNames()
        guard !filters.isEmpty else { return }
        let filtersViewController = FiltersViewControllers.createVC(with: filters, delegate: self)
        self.navigationController?.pushViewController(filtersViewController, animated: true)
    }
}

extension DrinksViewController: UITableViewDelegate, UITableViewDataSource {
        // MARK: - Table view data source

        func numberOfSections(in tableView: UITableView) -> Int {
            return dataSource.numberOfSections()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource.numberOfRowsInSection(section: section)
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! DrinkCell
            let drink = dataSource.drinkForIndexPath(indexPath: indexPath)
            cell.cocktailName.text = drink.name
            
            if drink.imageUrl != nil {
                let url = URL(string: drink.imageUrl!)!
            cell.cocktailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
            }
            return cell
        }        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return DrinkCell.cellHeight()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = dataSource.categoryForSection(section)
        return category.name?.uppercased() ?? NSLocalizedString("Empty name", comment: "")
    }
    
}

extension DrinksViewController {    
    func loadAllCategory() {
           dataSource.getCategoryCocktailsFromNetwork()
       }
}

    // MARK: - DrinksViewControllerDeleghate

extension DrinksViewController: FiltersViewControllerDelegate {    
    func filtersDidChange(category: [String]) {
        filterIsSelected(!category.isEmpty)
        dataSource.setCategoriesToFilter(from: category)
    }
    
    func didLoadCategories() {
        tableView.reloadData()
        dataSource.loadDrinksByCategories(dataSource.getCategories())
    }
    
    func didLoadDrinksForSection(section: Int) {
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        if section == dataSource.numberOfSections() - 1 {
            SVProgressHUD.dismiss()
        }
    }
    
    func willLoadDrinks() {
        SVProgressHUD.show()
        tableView.reloadData()
    }
}
