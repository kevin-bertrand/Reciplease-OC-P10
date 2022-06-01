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
    func configure(withRecipe recipe: Recipe) {
        plateImageView.image = UIImage(named: "default_recipe_background")
        if let url = recipe.image {
            plateImageView.dowloadFrom(url)
        }
        ingredientsLabel.text = recipe.ingredients.compactMap({$0.food}).joined(separator: ", ")
        plateTitleLabel.text = recipe.label
        yieldLabel.text = "\(recipe.yield) 👍"
        timeLabel.text = "\(recipe.totalTime.formatToStringTime)  🕓"
    }
    
    // MARK: Private
    // MARK: Outlet
    @IBOutlet private weak var plateImageView: UIImageView!
    @IBOutlet private weak var plateTitleLabel: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var yieldLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
}
