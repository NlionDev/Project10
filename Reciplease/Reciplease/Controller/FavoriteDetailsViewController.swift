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
    private let favoriteRecipesRepository = FavoriteRecipesRepositoryImplementation(container: PersistenceService.persistentContainer)
    private var isFav = true
    
    // MARK: - Outlets
    
    @IBOutlet weak private var cookingTimeLabel: UILabel!
    @IBOutlet weak private var recipeTitleLabel: UILabel!
    @IBOutlet weak private var recipeImageView: UIImageView!
    @IBOutlet weak private var favoriteDetailsTableView: UITableView!
    
    // MARK: - Lifecycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.favoriteDetailsTableView.reloadData()
            if let uri = self.selectedFavoriteRecipe.uri {
                do {
                self.isFav = (try self.favoriteRecipesRepository.getFavoriteRecipe(by: uri) != nil)
                } catch let error as FavoriteRecipeRequestError {
                    self.displayFavoriteRecipeError(error)
                } catch {
                    self.presentAlert(alertTitle: "Error", message: "Unknow error", actionTitle: "error")
                }
            }
            self.configurePage()
            self.setupStarButton(title: "Reciplease", action: #selector(self.didTapOnStarButton))
            self.configureStarButtonColor()
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapOnStarButton() {
        if isFav {
            if let ID = selectedFavoriteRecipe.uri {
                do {
                try favoriteRecipesRepository.removeRecipe(by: ID)
                } catch let error as FavoriteRecipeRequestError {
                    displayFavoriteRecipeError(error)
                } catch {
                    self.presentAlert(alertTitle: "Error", message: "Unknow error", actionTitle: "error")
                }
            }
        } else {
            if let image = selectedFavoriteRecipe.image,
                let label = selectedFavoriteRecipe.label,
                let ingredientLines = selectedFavoriteRecipe.ingredientLines,
                let uri = selectedFavoriteRecipe.uri {
                favoriteRecipesRepository.addRecipeToFavorite(totalTime: selectedFavoriteRecipe.totalTime, image: image, label: label, ingredientLines: ingredientLines, uri: uri)
            }
        }
        isFav.toggle()
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
    
    private func configureStarButtonColor() {
        if isFav {
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2650679648, green: 0.5823817849, blue: 0.364438206, alpha: 1)
        } else {
            self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    private func setupStarButton(title: String, action: Selector) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = title
        let starButton = UIBarButtonItem(image: #imageLiteral(resourceName: "whitestar"), style: .plain, target: self, action: action)
        self.navigationItem.rightBarButtonItem = starButton
    }
    

}

extension FavoriteDetailsViewController: UITableViewDataSource {
    
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
            cell.configure(title: ingredient)
        }
        
        return cell
        
    }
}

