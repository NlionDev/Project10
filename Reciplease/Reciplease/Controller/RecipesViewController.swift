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
    
    private var recipeRepo = RecipeRepositoryImplementation()
    var recipes: [Hit] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recipesTableView.reloadData()
                
            }
        }
    }
    
    var selectedRecipe: Recipe?

    //MARK: - Outlets
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.dataSource = self

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsSegueFromResults" {
            guard let VCDestination = segue.destination as? RecipeDetailsViewController,
            let selectedRecipe = selectedRecipe else { return }
            VCDestination.recipe = selectedRecipe
        }
    }
    
    //MARK: - Methods
    
}

//MARK: - Extensions

extension RecipesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesCell", for: indexPath) as? RecipeTableViewCell else {
            
            return UITableViewCell()
        }
        
        let recipesTitle = recipes[indexPath.row].recipe.label
        let recipesTime = recipes[indexPath.row].recipe.totalTime
        let recipeImageURLString = recipes[indexPath.row].recipe.image
        cell.configureCell(title: recipesTitle, time: recipesTime, imageURLString: recipeImageURLString)

        return cell
        
    }
}

extension RecipesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipes[indexPath.row].recipe
        performSegue(withIdentifier: "DetailsSegueFromResults", sender: self)
    }
}
