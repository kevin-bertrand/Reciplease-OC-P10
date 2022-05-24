//
//  IngredientCellView.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import UIKit

class IngredientCellView: UITableViewCell {
    // MARK: Public
    // MARK: View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Methods
    func configure(withIngredient ingredient: String) {
        _ingredientLabel.text = "- \(ingredient.localizedUppercase.trimmingCharacters(in: .whitespacesAndNewlines))"
    }
    
    // MARK: Private
    // MARK: Outlets
    @IBOutlet private weak var _ingredientLabel: UILabel!
}
