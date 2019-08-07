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
//    @IBOutlet weak var favoriteCookingTimeLabel: UILabel!
//    @IBOutlet weak var favoriteRecipeLabel: UILabel!
//    @IBOutlet weak var favoriteRecipeImage: UIImageView!
    
    //MARK: - Methods
    
    func configure(title: String, time: Int, imageURLString: String) {
        let cookingTime = String(time)
        recipesLabel.text = title
        cookingTimeLabel.text = cookingTime + "min"
        if let url = URL(string: imageURLString) {
            recipeImage.af_setImage(withURL: url, placeholderImage: UIImage(named: "food"))
        }
    }
    
//    func configureFavoriteCell(title: String, time: Int, imageURLString: String) {
//        let cookingTime = String(time)
//        favoriteRecipeLabel.text = title
//        favoriteCookingTimeLabel.text = cookingTime + "min"
//
//        if let url = URL(string: imageURLString) {
//            recipeImage.af_setImage(withURL: url, placeholderImage: UIImage(named: "food"))
//        }
//            favoriteRecipeImage.image = UIImage(imageLiteralResourceName: "food")
//
//    }
}
