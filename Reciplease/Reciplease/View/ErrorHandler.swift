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
    
    enum DownloadError {
        case DownloadFailed
    }
    
    func presentAlert(alertTitle: String, message: String, actionTitle: String) {
        let alertVC = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentError(_ error: DownloadError) {
        switch error {
        case .DownloadFailed:
            presentAlert(alertTitle: "Loading Failed.", message: "The Favorite Recipes loading failed", actionTitle: "OK")
        }
    }
}
