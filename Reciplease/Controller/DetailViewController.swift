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
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var getDirectionButton: UIButton!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    // MARK: Properties
    var recipeManager = RecipeManager()
    
    // MARK: Outlets
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _delegateSetup()
        _dataSourceSetup()
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
        plateNameLabel.accessibilityLabel  = plateNameLabel.text
        yieldLabel.text = "\(recipe.yield) 👍"
        yieldLabel.accessibilityLabel = "\(recipe.yield) likes"
        timeLabel.text = "\(recipe.totalTime.formatToStringTime) 🕓"
        timeLabel.accessibilityLabel = "\(recipe.totalTime.formatToStringTime) to prepare this recipe"
        
//        ingredientsTextView.text = ""
//        for ingredient in recipe.ingredientLines {
//            ingredientsTextView.text.append("- \(ingredient)\n")
//        }
//        ingredientsTextView.accessibilityLabel = ingredientsTextView.text
        
        if recipe.url == nil {
            getDirectionButton.isEnabled = false
            getDirectionButton.accessibilityHint = "Get direction button"
            getDirectionButton.accessibilityHint = "Go to the direction to prepare this recipe"
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

extension DetailViewController: UITableViewDelegate {
    // MARK: Private method
    /// Setup the delegate
    private func _delegateSetup() {
        ingredientTableView.delegate = self
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeManager.selectedRecipe?.ingredients.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "Ingredient-detailled-cell", for: indexPath) as? IngredientCellView, let selectedRecipe = recipeManager.selectedRecipe else {
            return UITableViewCell()
        }
        
        ingredientCell.configure(withIngredient: selectedRecipe.ingredientLines[indexPath.row])
        return ingredientCell
    }
    
    // MARK: Private method
    /// Setup the source of data
    private func _dataSourceSetup() {
        ingredientTableView.dataSource = self
    }
}
