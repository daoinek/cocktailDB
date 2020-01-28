//
//  FilterCell.swift
//  testTaskCocktails
//
//  Created by   on 4/24/19.
//  Copyright © 2019  . All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell  {
    
    // MARK: - Properties & IBOutlets
    
    @IBOutlet weak private var filterNameLabel: UILabel!
    
    //MARK: - Getters
    
    static func cellHeight() -> CGFloat {
        return 44.0
    }
    
    //MARK: - Setters
    
    func setFilterNameLabelText(text: String) {
        filterNameLabel.text = text
    }
}
