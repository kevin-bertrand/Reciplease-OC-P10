//
//  DegradedGrayView.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import UIKit

class DegradedGrayView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        _addGradientBackground()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func _addGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.init(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6).cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
}
