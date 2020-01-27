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

protocol DrinksDataSourceDelegate {
    func loadAllCategory()
    func didLoadCategories()
    func didLoadDrinksForSection(section: Int)
    func willLoadDrinks()
}


class DrinksViewController: UIViewController, DrinksDataSourceDelegate {
    
    private lazy var dataSource = DrinksDataSource(delegate: self)
    private lazy var spinnerVC = SpinnerViewController()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
        
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSpinnerView()
        loadAllCategory()
        addObserver()
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
        let cellNib = UINib.init(nibName: "CustomDrinkCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "customCell")
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.newData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func openSearch(_ sender: UIBarButtonItem) {
        routeToFilters()
    }
    
    
    private func routeToFilters() {
        let filters = dataSource.getCategoriesNames()
        guard !filters.isEmpty else { return }
        
        let filtersViewController = FilterViewController.createVC(with: filters, delegate: self)
        self.navigationController?.pushViewController(filtersViewController, animated: true)
    }
    
    @objc func newData() {
        self.tableView.reloadData()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomDrinkCell

            let drink = dataSource.drinkForIndexPath(indexPath: indexPath)

            cell.cocktailName.text = drink.name
            
            if drink.imageUrl != nil {
                let url = URL(string: drink.imageUrl!)!
            cell.cocktailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
            }
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return CustomDrinkCell.cellHeight()
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
    func createSpinnerView() {
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if SpinnerViewController.spinner == true {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                timer.invalidate()
                self.tableView.reloadData()
            }}
    }
    
    func loadAllCategory() {
           dataSource.getCategoryCocktailsFromNetwork()
       }
}

    // MARK: - DrinksViewControllerDeleghate

extension DrinksViewController: FiltersViewControllerDelegate {
    
    
    func filtersDidChange(category: String) {
        filterIsSelected(!category.isEmpty)
        dataSource.setCategoriesToFilter(from: [category])
        if category == "" {navigationItem.title = "Drinks"} else {
            navigationItem.title = category }
    }
    
    func didLoadCategories() {
        tableView.reloadData()
        
        dataSource.loadDrinksByCategories(dataSource.getCategories())
    }
    
    func didLoadDrinksForSection(section: Int) {
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        if section == dataSource.numberOfSections() - 1 {
            SpinnerViewController.spinner = true
        }
    }
    
    func willLoadDrinks() {
        SpinnerViewController.spinner = false
        createSpinnerView()
        tableView.reloadData()
    }
}
