//
//  IngredientTableViewCell.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak private var ingredientLabel: UILabel!
    
    
    //MARK: - Methods
    
    func configure(title: String) {
        ingredientLabel.text = "- " + title
    }
}
