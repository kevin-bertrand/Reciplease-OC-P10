//
//  RecipeCellView.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import UIKit

class RecipeCellView: UITableViewCell {
    // MARK: Public
    // MARK: View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Method
    /// Configure the table view cell
    func configure(withRecipe recipe: Recipe) {
        _plateImageView.image = UIImage(named: "default_recipe_background")
        if let url = recipe.image {
            _plateImageView.dowloadFrom(url)
        }
        _ingredientsLabel.text = recipe.ingredients.compactMap({$0.food}).joined(separator: ", ")
        _ingredientsLabel.accessibilityLabel = _ingredientsLabel.text
        _plateTitleLabel.text = recipe.label
        _plateTitleLabel.accessibilityLabel = _plateTitleLabel.text
        _yieldLabel.text = "\(recipe.yield) 👍"
        _yieldLabel.accessibilityLabel = "\(recipe.yield) likes"
        _timeLabel.text = "\(recipe.totalTime.formatToStringTime)  🕓"
        _timeLabel.accessibilityLabel = "\(recipe.totalTime.formatToStringTime) to prepare this recipe"
    }
    
    // MARK: Private
    // MARK: Outlet
    @IBOutlet private weak var _plateImageView: UIImageView!
    @IBOutlet private weak var _plateTitleLabel: UILabel!
    @IBOutlet private weak var _ingredientsLabel: UILabel!
    @IBOutlet private weak var _yieldLabel: UILabel!
    @IBOutlet private weak var _timeLabel: UILabel!
}
