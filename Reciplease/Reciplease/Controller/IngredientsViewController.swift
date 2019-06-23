//
//  ResearchViewController.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let recipeRepo = RecipeRepositoryImplementation()
    private var results: [Recipes] = []
    private var ingredients: [String] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    //MARK: - Actions

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientsTextField.resignFirstResponder()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        if let newIngredient = ingredientsTextField.text {
            ingredients.append(newIngredient)
            
            ingredientTableView.reloadData()
        }
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        ingredients.removeAll()
        ingredientTableView.reloadData()
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        let ingredients = joinIngredients()
        
        recipeRepo.getRecipes(ingredients: ingredients) { (result) in
            switch result {
            case .success(let searchResult):
                self.results = searchResult.hits
                self.performSegue(withIdentifier: "RecipeSegue", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeSegue" {
            guard let VCDestination = segue.destination as? RecipesViewController else { return }
            VCDestination.recipes = results
            VCDestination.getImagesURL()
            VCDestination.getRecipesImages()
        }
    }
    
    //MARK: - Methods
    
    private func joinIngredients() -> String {
       let allIngredients = ingredients.joined(separator: ",")
        return allIngredients
    }

}

//MARK: - Extensions

extension IngredientsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        
        let ingredient = ingredients[indexPath.row]
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


