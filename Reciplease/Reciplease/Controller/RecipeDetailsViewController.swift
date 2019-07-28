//
//  RecipeDetailsViewController.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit
import AlamofireImage

class RecipeDetailsViewController: UIViewController {

    // MARK: - Properties
    
    var recipe: Recipe!
    private let favoriteRecipesRepository = FavoriteRecipesRepositoryImplementation()
    private var isFav = true
    
    // MARK: - Outlets
    
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var recipeImageView: UIImageView!
    @IBOutlet weak private var detailsRecipeTableView: UITableView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isFav = (favoriteRecipesRepository.getFavoriteRecipe(by: recipe.uri) != nil)
        configurePage()
        setupStarButton(title: "Reciplease", action: #selector(didTapOnStarButton))
        configureStarButtonColor()
    }
    
    
    // MARK: - Actions
    
    @objc private func didTapOnStarButton() {
        if isFav {
            favoriteRecipesRepository.removeRecipe(by: recipe.uri)
        } else {
            favoriteRecipesRepository.addRecipeToFavorite(totalTime: recipe.totalTime, image: recipe.image, label: recipe.label, ingredientLines: recipe.ingredientLines, uri: recipe.uri)
        }
        configureStarButtonColor()
    }
    
    
    // MARK: - Methods
    
    private func configurePage() {
        let cookingTime = String(recipe.totalTime)
        if let url = URL(string: recipe.image) {
            timeLabel.text = cookingTime + "min"
            recipeImageView.af_setImage(withURL: url, placeholderImage: nil)
            titleLabel.text = recipe.label
            detailsRecipeTableView.reloadData()
        }
    }
    
    func configureStarButtonColor() {
        if isFav {
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2650679648, green: 0.5823817849, blue: 0.364438206, alpha: 1)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
}


// MARK: - Extensions

extension RecipeDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredientLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsIngredientsCell", for: indexPath) as? IngredientTableViewCell else {
            
            return UITableViewCell()
        }
        
        let ingredient = recipe.ingredientLines[indexPath.row]
            cell.configure(title: ingredient)
        
        return cell
        
    }
}

extension RecipeDetailsViewController {
    
    func setupStarButton(title: String, action: Selector) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = title
        let starButton = UIBarButtonItem(image: #imageLiteral(resourceName: "whitestar"), style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItem = starButton
    }
}
