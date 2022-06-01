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
    @IBOutlet weak var favouriteButton: UIBarButtonItem!
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
    @IBAction func toggleFavouriteButtonTouched(_ sender: Any) {
        guard let _ = recipeManager.selectedRecipe else { return }
        
        if recipeManager.selectedRecipe!.favourite == nil {
            recipeManager.selectedRecipe!.favourite = false
        }
        
        _updateDatabase()
        recipeManager.selectedRecipe!.favourite!.toggle()
        _updateFavouriteButtonColor()
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
        
        recipeManager.checkIfRecipeIsAlreadyInDatabase()
        _updateFavouriteButtonColor()
    }
    
    /// Update favourite button tint color
    private func _updateFavouriteButtonColor() {
        if recipeManager.isFavourite {
            favouriteButton.tintColor = UIColor(named: "Button Background")
        } else {
            favouriteButton.tintColor = UIColor(named: "ClearButtonBackground")
        }
    }
    
    private func _updateDatabase() {
        if recipeManager.isFavourite {
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
