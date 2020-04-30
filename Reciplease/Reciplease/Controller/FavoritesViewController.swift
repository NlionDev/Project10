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
    private var selectedRecipe: FavoriteRecipe?
    private var favoriteRecipes: [FavoriteRecipe] = []
    private let favoriteRecipeRepository = FavoriteRecipesRepositoryImplementation(container: PersistenceService.persistentContainer)

    // MARK: - Outlets
    @IBOutlet weak private var favoriteTableView: UITableView!
    @IBOutlet weak private var favoritesLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          do {
           self.favoriteRecipes = try self.favoriteRecipeRepository.getFavoriteRecipes()
        } catch let error as FavoriteRecipeRequestError {
            self.displayFavoriteRecipeError(error)
          } catch {
            self.presentAlert(alertTitle: "Error", message: "Unknow error", actionTitle: "error")
        }
            self.favoriteTableView.reloadData()
            self.showFavoritesLabel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegueFromFavorites" {
            guard let destination = segue.destination as? FavoriteDetailsViewController,
                let selectedRecipe = selectedRecipe else { return }
            destination.selectedFavoriteRecipe = selectedRecipe
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
}

// MARK: - Extension
extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? RecipeTableViewCell else {return UITableViewCell()}
        let recipesTitle = favoriteRecipes[indexPath.row].label
        let recipesTime = favoriteRecipes[indexPath.row].totalTime
        let recipeImageURLString = favoriteRecipes[indexPath.row].image
        if let recipesTitle = recipesTitle,
            let recipeImageURLString = recipeImageURLString {
            cell.configure(title: recipesTitle, time: recipesTime, imageURLString: recipeImageURLString)
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
            if let uri = favoriteRecipes[indexPath.row].uri {
                do {
                try favoriteRecipeRepository.removeRecipe(by: uri)
                } catch let error as FavoriteRecipeRequestError {
                    displayFavoriteRecipeError(error)
                } catch {
                    self.presentAlert(alertTitle: "Error", message: "Unknow error", actionTitle: "error")
                }
                PersistenceService.saveContext()
                do {
                favoriteRecipes = try favoriteRecipeRepository.getFavoriteRecipes()
                } catch let error as FavoriteRecipeRequestError {
                    displayFavoriteRecipeError(error)
                } catch {
                    self.presentAlert(alertTitle: "Error", message: "Unknow error", actionTitle: "error")
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
        }
    }
}
