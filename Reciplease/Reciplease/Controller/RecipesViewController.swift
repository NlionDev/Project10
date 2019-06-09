//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadRecipesTableView()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "sendRecipesSegue" {
//            let vc: IngredientsViewController = segue.destination as! IngredientsViewController
//            vc.delegate = self
//        }
//    }
    
    //MARK: - Methods
    
    func reloadRecipesTableView() {
        
    }
    
}

//MARK: - Extensions

extension RecipesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DownloadedRecipes.shared.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }

        let recipe = DownloadedRecipes.shared.recipes
        cell.configureCell(title: recipe[indexPath.row].recipe.label)

        return cell
    }

}

extension RecipesViewController: RecipesDelegate {
    func getRecipeLabel(_ viewController: IngredientsViewController, recipe: SearchResult) {
        let recipesResult = recipe.hits
        DownloadedRecipes.shared.recipes = recipesResult
        
        reloadRecipesTableView()
    }
}
