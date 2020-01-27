//
//  SpinnerViewController.swift
//  statogram
//
//  Created by Kostya Bershov on 03.01.2020.
//  Copyright © 2020 Kostya Bershov. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    
    static var spinner = false
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.65)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
