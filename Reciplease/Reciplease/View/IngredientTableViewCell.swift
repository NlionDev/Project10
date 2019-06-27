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
    
    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var detailsIngredientsLabel: UILabel!
    
    
    //MARK: - Methods
    
    func configureIngredientsCell(title: String) {
        ingredientLabel.text = "- " + title
    }
    
    func configureDetailsIngredientsCell(title: String) {
        detailsIngredientsLabel.text = "- " + title
    }
}
