//
//  CocktailCell.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 11.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit

class CustomCocktailCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cocktailImage: UIImageView!
    @IBOutlet weak var cocktailName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        cellView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)

        // Configure the view for the selected state
    }

}
