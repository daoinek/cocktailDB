//
//  DrinkCategoryHeader.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 22.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit

class DrinkCategoryHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var categoryLabel: UILabel!
    
    static func headerHeight() -> CGFloat {
        return 30.0
    }
    
    func setcategoryLabelText(text: String) {
        categoryLabel.text = text
    }

}
