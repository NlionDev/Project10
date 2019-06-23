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
    var recipes: [Recipes] = [] {
        didSet {
            DispatchQueue.main.async {
                self.recipesTableView.reloadData()
                
            }
        }
    }
    
    private var imagesURL: [String] = []
    private var recipesImages: [UIImage] = []

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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Int) {
//        if segue.identifier == "DetailsSegueFromResults" {
//            guard let VCDestination = segue.destination as? RecipeDetailsViewController else { return }
//            VCDestination.recipe = recipes[sender]
//
//        }
//    }
    
    //MARK: - Methods
    
    func getImagesURL() {
        for recipe in recipes {
            imagesURL.append(recipe.recipe.image)
        }
    }
    
    func getRecipesImages() {
        
        for url in imagesURL {
            recipeRepo.getImages(url: url) { (result) in
                switch result {
                case .success(let image):
                    
                    self.recipesImages.append(image)
                    
                case .failure(_):
                    
                    self.presentAlert(alertTitle: "Error", message: "The Recipes Image download fail", actionTitle: "OK")
                }
            }
        }
        
    }
    
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
        let recipeImage = UIImage(named: "food")
        cell.configureCell(title: recipesTitle, time: recipesTime, image: recipeImage!)

        return cell
        
    }
}

extension RecipesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
