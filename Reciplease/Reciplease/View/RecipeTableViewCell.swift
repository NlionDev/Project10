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
    
    //MARK: - Methods
    func configure(title: String, time: Int, imageURLString: String) {
        let cookingTime = String(time)
        recipesLabel.text = title
        cookingTimeLabel.text = cookingTime + "min"
        if let url = URL(string: imageURLString) {
            recipeImage.af_setImage(withURL: url, placeholderImage: UIImage(named: "food"))
        }
    }

}
