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
    var favoriteRecipes: [FavoriteRecipe] = []
    private let favoriteRecipesRepository = FavoriteRecipesRepositoryImplementation()
    
    // MARK: - Outlets
    
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var recipeImageView: UIImageView!
    @IBOutlet weak private var detailsRecipeTableView: UITableView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoriteRecipes = self.favoriteRecipesRepository.getFavoriteRecipes()
        configurePage()
        setupStarButton(title: "Reciplease", action: #selector(didTapOnStarButton))
        configureStarButtonColor()
    }
    
    
    // MARK: - Actions
    
    @objc private func didTapOnStarButton() {
        if checkIfIsFavorites() {
            removeRecipeOfFavorites()
        } else {
            favoriteRecipesRepository.addRecipeToFavoriteFromDetails(recipe: recipe)
            favoriteRecipes = favoriteRecipesRepository.getFavoriteRecipes()
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
    
    func checkIfIsFavorites() -> Bool {
        var result = false
        for favoriteRecipe in favoriteRecipes {
            if favoriteRecipe.label == recipe.label {
                result = true
            }
        }
        return result
    }
    
    func getIndexForFavoriteRecipe() -> Int {
        var index = 0
        for favoriteRecipe in favoriteRecipes {
            index += 1
            if favoriteRecipe.label == recipe.label {
                index -= 1
                break
            }
        }
        return index
    }
    
    func configureStarButtonColor() {
        if checkIfIsFavorites() {
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2650679648, green: 0.5823817849, blue: 0.364438206, alpha: 1)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func removeRecipeOfFavorites() {
        let index = getIndexForFavoriteRecipe()
        let recipe = favoriteRecipes[index]
        PersistenceService.context.delete(recipe)
        PersistenceService.saveContext()
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
