//
//  UIView+ReuseIdentifier.swift
//  cocktail-db
//
//  Created by Kostya Bershov on 28.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
