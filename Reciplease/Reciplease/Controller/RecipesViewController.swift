//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RecipesViewController: UIViewController {

    //MARK: - Properties
    
    private var recipeRepository = RecipeRepositoryImplementation()
    var recipes: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recipesTableView.reloadData()
                
            }
        }
    }
    
    private var selectedRecipe: Recipe?

    //MARK: - Outlets
    
    @IBOutlet weak private var recipesTableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.dataSource = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegueFromResults" {
            guard let destination = segue.destination as? RecipeDetailsViewController,
            let selectedRecipe = selectedRecipe else { return }
            destination.recipe = selectedRecipe
        }
    }
    
    //MARK: - Methods
    
}

//MARK: - Extensions

extension RecipesViewController: UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesCell", for: indexPath) as? RecipeTableViewCell else {
            
            return UITableViewCell()
        }
        
        let recipesTitle = recipes[indexPath.row].label
        let recipesTime = recipes[indexPath.row].totalTime
        let recipeImageURLString = recipes[indexPath.row].image
        cell.configure(title: recipesTitle, time: recipesTime, imageURLString: recipeImageURLString)

        return cell
        
    }
}

extension RecipesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipes[indexPath.row]
        performSegue(withIdentifier: "DetailsSegueFromResults", sender: self)
    }
}
