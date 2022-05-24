//
//  InfoTilesView.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import UIKit

class InfoTilesView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        _drawBorder()
    }

    private func _drawBorder() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
}
