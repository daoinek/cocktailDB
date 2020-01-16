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


class CocktailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Variables
    
    lazy var spinnerViewController = SpinnerViewController()
    lazy var cocktailsDataSource = CocktailsDataSource()
    private var contentOffset: CGPoint?
    private var allCocktails: [String: [[String: String]]]?
    private var selectedArray: [String: [[String: String]]] = [:]
    var dataIsLoaden = false

    
    
    // MARK: - Outlets

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadSelectedArray), name: NSNotification.Name(rawValue: "selectedCategory"), object: nil)
        
        tableView.tableFooterView = UIView()
        cocktailsDataSource.getCategoryCocktailsFromNetwork()
        createSpinnerView()
        
        let nib = UINib.init(nibName: "CocktailCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "customCell")
      // self.navigationController?.navigationBar.addSubview(HeaderForCocktails.instanceFromNib())
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        selectedCategoryIndex = cocktailsDataSource.getSelectedCategoryIndex()
        if cocktailsDataSource.backFromFilterStatus() {
            self.tableView.setContentOffset(contentOffset!, animated: true)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.contentOffset = self.tableView.contentOffset
    }
    
    
    @IBAction func openSearch(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "openFilter", sender: nil)
    }


    @objc func refresh() {
        allCocktails = cocktailsDataSource.getAllCoctailsArray()
        dataIsLoaden = true
        self.tableView.reloadData() // a refresh the tableView.
    }
    
    @objc func loadSelectedArray() {
        filterButton.image = UIImage(named: "filter_on.png")
        selectedArray = selectedCategoryArray!
        self.tableView.reloadData()
    }
    

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        if selectedCategoryIndex != nil {
            return 1
        }
        
        guard let allCocktails = allCocktails?.count else { return 0 }
        return allCocktails
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if selectedCategoryIndex != nil {
            if selectedCategoryArray != nil {
            let valueArray = Array(selectedArray.values)
                return valueArray[0].count
            } else {
                cocktailsDataSource.displayWarningLable(text: "Данные еще не загрузились", vc: self)
                selectedCategoryIndex = nil
            }
        }
        
        guard let valueArray0 = allCocktails else { return 0 }
        let valueArray = Array(valueArray0.values)
        return valueArray[section].count
            
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCocktailCell

        if selectedCategoryIndex != nil {
            let valueArray = Array(selectedArray.values)
            cell.cocktailName.text = valueArray[0][indexPath.row]["strDrink"]
            
            let url = URL(string: valueArray[0][indexPath.row]["strDrinkThumb"]!)!
            cell.cocktailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
        } else {
            if allCocktails != nil {
            let valueArray = Array(allCocktails!.values)
            cell.cocktailName.text = valueArray[indexPath.section][indexPath.row]["strDrink"]
            
            let url = URL(string: valueArray[indexPath.section][indexPath.row]["strDrinkThumb"]!)!
            cell.cocktailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_image"), options: .continueInBackground, completed: nil)
            }
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
            let category = Array(allCocktails!.keys)
            return category[section]
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! FilterViewController
            destinationVC.allCocktails = allCocktails
    }


}

extension CocktailsViewController{
    func createSpinnerView() {
        let child = SpinnerViewController()
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.dataIsLoaden == true {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                timer.invalidate()
            }}
    }
}
