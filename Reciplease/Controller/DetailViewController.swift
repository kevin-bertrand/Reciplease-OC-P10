//
//  DetailViewController.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    // MARK: Public
    // MARK: Outlet
    @IBOutlet weak var plateImage: UIImageView!
    @IBOutlet weak var plateNameLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var getDirectionButton: UIButton!
    
    // MARK: Properties
    var recipeManager = RecipeManager()
    
    // MARK: Outlets
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _configureView()
    }
    
    // MARK: Action
    @IBAction func toggleFavoriteButtonTouched(_ sender: Any) {
        guard let _ = recipeManager.selectedRecipe else { return }
        _updateDatabase()
        recipeManager.selectedRecipe!.favorite!.toggle()
        _updateFavoriteButtonColor()
    }
    
    @IBAction func getDirectionButtonTouched(_ sender: Any) {
        if let url = recipeManager.selectedRecipe?.url {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: Private
    // MARK: Methods
    /// Configure the view when it is shown
    private func _configureView() {
        guard let recipe = recipeManager.selectedRecipe else { return }
        plateImage.image = UIImage(named: "default_recipe_background")
        if let url = recipe.image {
            plateImage.dowloadFrom(url)
        }
        plateNameLabel.text = recipe.label
        yieldLabel.text = "\(recipe.yield) 👍"
        timeLabel.text = "\(recipe.totalTime.formatToStringTime) 🕓"
        
        ingredientsTextView.text = ""
        for ingredient in recipe.ingredientLines {
            ingredientsTextView.text.append("- \(ingredient)\n")
        }
        
        if recipe.url == nil {
            getDirectionButton.isEnabled = false
        }
        
        _updateFavoriteButtonColor()
    }
    
    /// Update favorite button tint color
    private func _updateFavoriteButtonColor() {
        if recipeManager.selectedRecipeIsFavorite {
            favoriteButton.tintColor = UIColor(named: "Button Background")
        } else {
            favoriteButton.tintColor = UIColor(named: "ClearButtonBackground")
        }
    }
    
    /// Update the database (save or delete the record)
    private func _updateDatabase() {
        if recipeManager.selectedRecipeIsFavorite {
            if let error = recipeManager.deleteRecordOnDatabase() {
                AlertManager.shared.sendAlert(error, on: self)
            }
        } else {
            if let error = recipeManager.saveRecordOnDatabase() {
                AlertManager.shared.sendAlert(error, on: self)
            }
        }
    }
}
