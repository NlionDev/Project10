//
//  CookingTimeView.swift
//  Reciplease
//
//  Created by Nicolas Lion on 01/07/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class CookingTimeView: UIView {
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    //MARK: - Methods
    private func configureView() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.backgroundColor = #colorLiteral(red: 0.1945961416, green: 0.1799771488, blue: 0.1758020818, alpha: 1)
    }
    
}
