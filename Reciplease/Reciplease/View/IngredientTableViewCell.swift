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
    
    
    //MARK: - Methods
    
    func configureCell(title: String) {
        ingredientLabel.text = "- " + title
    }
}
