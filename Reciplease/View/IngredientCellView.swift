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
    /// Configure the table view cell
    func configure(withIngredient ingredient: String) {
        _ingredientLabel.text = "- \(ingredient.trimmingCharacters(in: .whitespacesAndNewlines).capitalizingFirstLetter())"
        _ingredientLabel.accessibilityLabel = ingredient
    }
    
    // MARK: Private
    // MARK: Outlets
    @IBOutlet private weak var _ingredientLabel: UILabel!
}
