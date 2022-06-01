//
//  InfoTilesView.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import UIKit

class InfoTilesView: UIView {
    // MARK: Public
    // MARK: View life cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        _drawBorder()
    }

    // MARK: Private
    // MARK: Method
    /// Draw a border around a view
    private func _drawBorder() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
}
