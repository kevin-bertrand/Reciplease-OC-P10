//
//  DegradedGrayView.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import UIKit

class DegradedGrayView: UIView {
    // MARK: Public
    // MARK: View life cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !_firstLoad {
            _addGradientBackground()
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private var _firstLoad = false
    
    // MARK: Method
    /// Adding a linear gradient from top to bottom on a view
    private func _addGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.type = .axial
        gradient.colors = [UIColor.init(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.825).cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
        _firstLoad = true
    }
}
