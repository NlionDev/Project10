//
//  ResearchViewController.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit

protocol RecipesDelegate {
    func getRecipeLabel(_ viewController: IngredientsViewController, recipe: SearchResult)
}

class IngredientsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let recipeRepo = RecipeRepositoryImplementation()
    var delegate: RecipesDelegate?

    //MARK: - Outlets
    
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    //MARK: - Actions

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientsTextField.resignFirstResponder()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        if let newIngredient = ingredientsTextField.text {
            Ingredients.shared.ingredients.append(newIngredient)
            
            ingredientTableView.reloadData()
        }
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        Ingredients.shared.ingredients.removeAll()
        ingredientTableView.reloadData()
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        recipeRepo.getRecipes { (result) in
            switch result {
            case .success(let searchResult):
                self.sendData(result: searchResult)
            case .failure(_):
                
                self.presentAlert(alertTitle: "Error", message: "The recipes download fail.", actionTitle: "OK")
            }
        }
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTextField.clearsOnBeginEditing = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientTableView.reloadData()
    }
    
    //MARK: - Methods
    
    private func sendData(result: SearchResult) {
            delegate?.getRecipeLabel(self, recipe: result)
        
    }
//    private func getRecipeLabel(recipe: SearchResult) {
//        let recipesResult = recipe.hits
//        DownloadedRecipes.shared.recipes = recipesResult
//
//
//    }

}

//MARK: - Extensions

extension IngredientsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Ingredients.shared.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        
        let ingredient = Ingredients.shared.ingredients[indexPath.row]
        cell.configureCell(title: ingredient)
        
        return cell
    }
}

extension IngredientsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


