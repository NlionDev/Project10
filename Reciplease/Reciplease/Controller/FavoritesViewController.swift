//
//  FavoritesViewController.swift
//  Reciplease
//
//  Created by Nicolas Lion on 26/06/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

class FavoritesViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        makeFetchRequest()
        favoriteTableView.reloadData()
        showFavoritesLabel()
    }
    
    // MARK: - Methods
    
    private func showFavoritesLabel() {
        if FavoritesRecipes.shared.favoritesRecipes.isEmpty {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesRecipes.shared.favoritesRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? RecipeTableViewCell else {
            
            return UITableViewCell()
        }
        
        let recipesTitle = FavoritesRecipes.shared.favoritesRecipes[indexPath.row].name
        let recipesTime = FavoritesRecipes.shared.favoritesRecipes[indexPath.row].cookingTime
        let recipeImageURLString = FavoritesRecipes.shared.favoritesRecipes[indexPath.row].imageURLString
        if let recipesTitle = recipesTitle,
            let recipeImageURLString = recipeImageURLString {
            cell.configureFavoriteCell(title: recipesTitle, time: recipesTime, imageURLString: recipeImageURLString)
        }
        return cell
        
    }
}
