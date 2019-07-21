//
//  ResearchViewController.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import UIKit
import CoreData

class IngredientsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let recipeRepository = RecipeRepositoryImplementation()
    private let ingredientRepository = IngredientsRepositoryImplementation()
    private var results: [Hit] = []
    private var ingredients: [Ingredient] = []
    private var ingredientsName: [String] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak private var ingredientsTextField: UITextField!
    @IBOutlet weak private var ingredientTableView: UITableView!
    
    //MARK: - Actions

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientsTextField.resignFirstResponder()
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        if let newIngredientName = ingredientsTextField.text {
            ingredientRepository.saveIngredient(name: newIngredientName)
            self.getIngredients()
            ingredientTableView.reloadData()
        }
    }
    
    @IBAction func didTapClearButton(_ sender: Any) {
        ingredientsName.removeAll()
        ingredientTableView.reloadData()
    }
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        let ingredients = joinIngredients()
        
        recipeRepository.getRecipes(ingredients: ingredients) { (result) in
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
        getIngredients()
        ingredientTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeSegue" {
            guard let VCDestination = segue.destination as? RecipesViewController else { return }
            VCDestination.recipes = results
        }
    }
    
    //MARK: - Methods
    
    private func joinIngredients() -> String {
       let allIngredients = ingredientsName.joined(separator: ",")
        return allIngredients
    }
    
    private func getIngredients() {
        ingredientsName = ingredientRepository.makeFetchRequestForNames()
        ingredients = ingredientRepository.makeFetchRequestForIngredients()
    }
}

//MARK: - Extensions

extension IngredientsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        
        let ingredient = ingredientsName[indexPath.row]
        cell.configureIngredientsCell(title: ingredient)
        
        return cell
        
    }
}

extension IngredientsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientRepository.removeIngredient(ingredient: ingredients[indexPath.row])
            PersistenceService.saveContext()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
}

extension IngredientsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


