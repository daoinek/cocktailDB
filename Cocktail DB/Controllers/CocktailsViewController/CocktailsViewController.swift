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


class CocktailsViewController: UIViewController, CocktailsDataSourceDelegate {
    
    private lazy var dataSource = CocktailsDataSource(delegate: self)
    private lazy var spinnerViewController = SpinnerViewController()
    private var contentOffset: CGPoint?
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
        
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSpinnerView(type: "dataIsLoaden")
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
        let cellNib = UINib.init(nibName: "CocktailCell", bundle: nil)
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
        self.contentOffset = self.tableView.contentOffset
    }
    
    
    @IBAction func openSearch(_ sender: UIBarButtonItem) {
        routeToFilters()
    }
    
    
    private func routeToFilters() {
        let allCategories = dataSource.getCategories()
        guard !allCategories.isEmpty else { return }
        
        let filtersViewController = FilterViewController.createVC(with: allCategories, delegate: self, selectedCategory: dataSource.getSelectedCategoryName())
        self.navigationController?.pushViewController(filtersViewController, animated: true)
    }
    
    @objc func newData() {
        self.tableView.reloadData()
    }

}

extension CocktailsViewController: UITableViewDelegate, UITableViewDataSource {
        // MARK: - Table view data source

        func numberOfSections(in tableView: UITableView) -> Int {

            return dataSource.numberOfSections()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return dataSource.numberOfRowsInSection(section: section)
        }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCocktailCell

            let drink = dataSource.drinkForIndexPath(indexPath: indexPath)
            cell.cocktailName.text = drink["strDrink"]
            
            if drink["strDrinkThumb"] != nil {
            let url = URL(string: drink["strDrinkThumb"]!)!
            cell.cocktailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
            }
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return CustomCocktailCell.cellHeight()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
                    
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard dataSource.getSelectedCategoryName() == nil else { return nil}
        return dataSource.categoryForSection(section)
    }
    
}

extension CocktailsViewController {
    func createSpinnerView(type: String) {
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            var spinner = false
            if type == "dataIsLoaden" {spinner = CocktailsDataSource.dataIsLoaden } else { spinner = CocktailsDataSource.filterIsLoaden }
            if spinner == true {
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

extension CocktailsViewController: FiltersViewControllerDelegate {
    
    func filtersDidChange(filters: String) {
        filterIsSelected(!filters.isEmpty)
        dataSource.setCategoriesToFilter(from: filters)
        createSpinnerView(type: "filterIsLoaden")
        if filters == "" {navigationItem.title = "Drinks"} else {
            navigationItem.title = filters }
    }
    
    func backFromFilter() {
        self.tableView.setContentOffset(contentOffset!, animated: true)
        self.tableView.reloadData()
    }
}
