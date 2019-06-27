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
    
    // MARK: - Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var detailsRecipeTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeFetchRequest()
        configurePage()
        setupStarButton(title: "Reciplease", action: #selector(didTapOnStarButton))
        configureStarButtonColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Actions
    
    @objc private func didTapOnStarButton() {
        if checkIfIsFavorites() {
            removeRecipeOfFavorites()
        } else {
            saveRecipeOnFavorites()
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
    
    private func configureStarButtonColor() {
        if checkIfIsFavorites() {
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2650679648, green: 0.5823817849, blue: 0.364438206, alpha: 1)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    private func checkIfIsFavorites() -> Bool {
        var result = false
        for favoriteRecipe in FavoritesRecipes.shared.favoritesRecipes {
            if favoriteRecipe.name == recipe.label {
                result = true
            }
        }
        return result
    }
    
    private func getIndexForFavoriteRecipe() -> Int {
        var index = 0
        for favoriteRecipe in FavoritesRecipes.shared.favoritesRecipes {
            index += 1
            if favoriteRecipe.name == recipe.label {
                index -= 1
                break
            }
        }
        return index
    }
    
    private func saveRecipeOnFavorites() {
        let favoriteRecipe = FavoriteRecipe(context: PersistenceService.context)
        favoriteRecipe.cookingTime = Int16(recipe.totalTime)
        favoriteRecipe.imageURLString = recipe.image
        favoriteRecipe.name = recipe.label
        favoriteRecipe.ingredients = recipe.ingredientLines
        PersistenceService.saveContext()
        FavoritesRecipes.shared.favoritesRecipes.append(favoriteRecipe)
    }
    
    private func removeRecipeOfFavorites() {
        let index = getIndexForFavoriteRecipe()
        FavoritesRecipes.shared.favoritesRecipes.remove(at: index)
        PersistenceService.saveContext()
    }

}


// MARK: - Extensions

extension RecipeDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredientLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsIngredientsCell", for: indexPath) as? IngredientTableViewCell else {
            
            return UITableViewCell()
        }
        
        let ingredient = recipe.ingredientLines[indexPath.row]
            cell.configureDetailsIngredientsCell(title: ingredient)
        
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
