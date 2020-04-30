//
//  RecipeIngredientsTableViewCell.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/04/2020.
//  Copyright © 2020 Nicolas Lion. All rights reserved.
//

import UIKit

class RecipeIngredientsTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var ingredientLabel: UILabel!
    
    //MARK: - Methods
    func configure(title: String) {
        ingredientLabel.text = "- " + title
    }
    
}
