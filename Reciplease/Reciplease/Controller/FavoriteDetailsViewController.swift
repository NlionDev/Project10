//
//  FavoriteDetailsViewController.swift
//  Reciplease
//
//  Created by Nicolas Lion on 28/06/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit

class FavoriteDetailsViewController: UIViewController {

    
    // MARK: - Properties
    
    var selectedFavoriteRecipe: FavoriteRecipe!
    var favoriteRecipes: [FavoriteRecipe] = []
    let favoriteRecipesRepo = FavoriteRecipesRepositoryImplementation()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var favoriteDetailsTableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.favoriteDetailsTableView.reloadData()
            self.configurePage()
            self.setupStarButton(title: "Reciplease", action: #selector(self.didTapOnStarButton))
            self.configureStarButtonColor()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapOnButton(_ sender: Any) {
        
    
    }
    
    @objc private func didTapOnStarButton() {
        if checkIfIsFavorites() {
            let index = getIndexForFavoriteRecipe()
            let recipe = favoriteRecipes[index]
            favoriteRecipesRepo.removeRecipeOfFavorites(recipe: recipe)
        } else {
            favoriteRecipesRepo.addRecipeToFavoriteFromFavorite(recipe: selectedFavoriteRecipe)
        }
        configureStarButtonColor()
    }
    
    // MARK: - Methods
    
    private func configurePage() {
        let cookingTime = String(selectedFavoriteRecipe.totalTime)
        guard let image = selectedFavoriteRecipe.image else { return }
        if let url = URL(string: image) {
            cookingTimeLabel.text = cookingTime + "min"
            recipeImageView.af_setImage(withURL: url, placeholderImage: nil)
            recipeTitleLabel.text = selectedFavoriteRecipe.label
            favoriteDetailsTableView.reloadData()
        }
    }
    
    func checkIfIsFavorites() -> Bool {
        var result = false
        for favoriteRecipe in favoriteRecipes {
            if favoriteRecipe.label == selectedFavoriteRecipe.label {
                result = true
            }
        }
        return result
    }
    
    func getIndexForFavoriteRecipe() -> Int {
        var index = 0
        for favoriteRecipe in favoriteRecipes {
            index += 1
            if favoriteRecipe.label == selectedFavoriteRecipe.label {
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
    

}

extension FavoriteDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       guard let ingredients = selectedFavoriteRecipe.ingredientLines  else { return 0 }
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsFavoritesCell", for: indexPath) as? IngredientTableViewCell else {
            
            return UITableViewCell()
        }
        
        if let ingredients = selectedFavoriteRecipe.ingredientLines {
            let ingredient = ingredients[indexPath.row]
            cell.configureDetailsIngredientsCell(title: ingredient)
        }
        
        return cell
        
    }
}

extension FavoriteDetailsViewController {
    
    func setupStarButton(title: String, action: Selector) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = title
        let starButton = UIBarButtonItem(image: #imageLiteral(resourceName: "whitestar"), style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItem = starButton
    }
}
