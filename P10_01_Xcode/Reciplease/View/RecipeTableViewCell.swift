//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak private var recipeImage: UIImageView!
    @IBOutlet weak private var recipesLabel: UILabel!
    @IBOutlet weak private var cookingTimeLabel: UILabel!
    @IBOutlet weak private var ingredientsLabel: UILabel!
    
    //MARK: - Methods
    func configure(title: String, time: Int, imageURLString: String, ingredients: String) {
        let cookingTime = String(time)
        if cookingTime == "0" {
            cookingTimeLabel.text = "N/A"
        } else {
            cookingTimeLabel.text = cookingTime + "min"
        }
        recipesLabel.text = title
        ingredientsLabel.text = ingredients
        if let url = URL(string: imageURLString) {
            recipeImage.af_setImage(withURL: url, placeholderImage: UIImage(named: "food"))
        }
    }

}
