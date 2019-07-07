//
//  FavoritesViewController.swift
//  Reciplease
//
//  Created by Nicolas Lion on 26/06/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit
import AlamofireImage

class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedRecipe: FavoriteRecipe?
    var favoriteRecipes: [FavoriteRecipe] = []
    let favoriteRecipeRepo = FavoriteRecipesRepositoryImplementation()

    // MARK: - Outlets
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.getFavoriteRecipes()
            self.favoriteTableView.reloadData()
            self.showFavoritesLabel()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegueFromFavorites" {
            guard let VCDestination = segue.destination as? FavoriteDetailsViewController,
                let selectedRecipe = selectedRecipe else { return }
            VCDestination.selectedFavoriteRecipe = selectedRecipe
            VCDestination.favoriteRecipes = favoriteRecipes
        }
    }
    
    // MARK: - Methods
    
    private func showFavoritesLabel() {
        if favoriteRecipes.isEmpty {
            favoriteTableView.isHidden = true
            favoritesLabel.isHidden = false
        } else {
            favoritesLabel.isHidden = true
            favoriteTableView.isHidden = false
        }
    }
    
    private func getFavoriteRecipes() {
        favoriteRecipes = favoriteRecipeRepo.makeFetchRequest()
    }
    
    
}

// MARK: - Extension

extension FavoritesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? RecipeTableViewCell else {
            
            return UITableViewCell()
        }
        
        let recipesTitle = favoriteRecipes[indexPath.row].label
        let recipesTime = favoriteRecipes[indexPath.row].totalTime
        let recipeImageURLString = favoriteRecipes[indexPath.row].image
        if let recipesTitle = recipesTitle,
            let recipeImageURLString = recipeImageURLString {
            cell.configureFavoriteCell(title: recipesTitle, time: recipesTime, imageURLString: recipeImageURLString)
        }
        return cell
        
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = favoriteRecipes[indexPath.row]
        
        performSegue(withIdentifier: "DetailsSegueFromFavorites", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteRecipeRepo.removeRecipeOfFavorites(recipe: favoriteRecipes[indexPath.row])
            PersistenceService.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
}
