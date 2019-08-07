//
//  ErrorHandler.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func presentAlert(alertTitle: String, message: String, actionTitle: String) {
        let alertVC = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func displayIngredientError(_ error: IngredientRequestError) {
        switch error {
        case .requestForIngredientsNamesError:
            presentAlert(alertTitle: "Error", message: "Can not retrieve the ingredient names", actionTitle: "OK")
        case .requestForIngredientsError:
            presentAlert(alertTitle: "Error", message: "Impossible to recover the ingredients", actionTitle: "OK")
        }
    }
    func displayFavoriteRecipeError(_ error: FavoriteRecipeRequestError) {
        switch error {
        case .requestForFavoriteRecipesError:
            presentAlert(alertTitle: "Error", message: "Can not retrieve the Favorite Recipes", actionTitle: "OK")
        case .requestForGettingRecipeByUriError:
            presentAlert(alertTitle: "Error", message: "Impossible to recover the Favorite Recipe", actionTitle: "OK")
        case .removingRecipeError:
            presentAlert(alertTitle: "Error", message: "Impossible to remove this Recipe", actionTitle: "OK")
        }
    }

}
