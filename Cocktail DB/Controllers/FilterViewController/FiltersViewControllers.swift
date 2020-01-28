//
//  FilterViewController.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 11.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit

public protocol FiltersViewControllerDelegate {
    func filtersDidChange(category: [String])
}

class FiltersViewControllers: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets & Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyFiltersButton: UIButton!
    
    private var delegate: FiltersViewControllerDelegate?
    
    private static var allCocktailsCategory = [String]()
    private static var previousSelectedFilters: [String]?
    private var currentSelectedFilter = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDesignAndXib()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    // MARK: - Init
        
    static func createVC(with category: [String], delegate: FiltersViewControllerDelegate) -> FiltersViewControllers {
        let vc = UIStoryboard(name: "FilterViewController", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FiltersViewControllers
        
        if FiltersViewControllers.allCocktailsCategory.isEmpty {
            FiltersViewControllers.allCocktailsCategory = category
        }
        
        vc.delegate = delegate        
        return vc
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    private func updateApplyButton() {
        applyFiltersButton.isEnabled = isFiltersChanged()
    }
    
    private func isFiltersChanged() -> Bool {
        guard let previousFilters = FiltersViewControllers.previousSelectedFilters else { return true }
        return previousFilters != currentSelectedFilter
    }
    
    
    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyFilters(_ sender: UIButton) {
        delegate!.filtersDidChange(category: currentSelectedFilter)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FiltersViewControllers.allCocktailsCategory.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "categoryInFilter", for: indexPath)
        cell.textLabel?.text = FiltersViewControllers.allCocktailsCategory[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath)  {
            cell.accessoryType = .checkmark
        currentSelectedFilter.append(FiltersViewControllers.allCocktailsCategory[indexPath.row])
            updateApplyButton()
        }
    }
}

extension FiltersViewControllers {
    
    func loadDesignAndXib() {
    tableView.tableFooterView = UIView()
    applyFiltersButton.layer.borderWidth = 1
    applyFiltersButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    applyFiltersButton.layer.cornerRadius = 15
    applyFiltersButton.layer.masksToBounds = true
        
    tableView.register(FilterCell.nib, forCellReuseIdentifier: FilterCell.identifier)
        
    self.navigationItem.hidesBackButton = true
    let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(FiltersViewControllers.back(sender:)))
    self.navigationItem.leftBarButtonItem = newBackButton
    }
}
