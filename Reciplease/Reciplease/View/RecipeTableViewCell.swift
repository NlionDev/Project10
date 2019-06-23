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
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipesLabel: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    
    //MARK: - Methods
    
    func configureCell(title: String, time: Int, image: UIImage) {
        let cookingTime = String(time)
        recipesLabel.text = title
        cookingTimeLabel.text = cookingTime + "min"
        recipeImage.image = image
    }

}
