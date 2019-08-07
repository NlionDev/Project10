//
//  ButtonsView.swift
//  Reciplease
//
//  Created by Nicolas Lion on 30/05/2019.
//  Copyright © 2019 Nicolas Lion. All rights reserved.
//

import Foundation
import UIKit

class ButtonsView: UIButton {
    
    //MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureButtonStyle()
        
    }
    
    //MARK: - Methods
    private func configureButtonStyle() {
        self.layer.cornerRadius = 5
    }
}
