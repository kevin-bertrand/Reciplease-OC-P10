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
    
    // MARK: Properties
    var recipe: RecipeInformations?
    var favouriteRecipe: FavouriteRecipes?
    
    // MARK: Outlets
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _configureView()
    }
    
    // MARK: Action
    @IBAction func toggleFavouriteButtonTouched(_ sender: Any) {
        guard let _ = recipe else { return }
        
        if recipe!.favourite == nil {
            recipe!.favourite = false
        }
        
        recipe!.favourite!.toggle()
        _updateFavouriteButtonColor()
        _updateDatabase()
    }
    
    // MARK: Private
    // MARK: Properties
    
    // MARK: Methods
    /// Configure the view when it is shown
    private func _configureView() {
        guard let recipe = recipe else { return }
        if let url = recipe.image {
            plateImage.dowloadFrom(url)
        } else {
            plateImage.image = UIImage(named: "default_recipe_background")
        }
        plateNameLabel.text = recipe.label
        yieldLabel.text = "\(recipe.yield) 👍"
        timeLabel.text = "\(recipe.totalTime.formatToStringTime) 🕓"
        
        ingredientsTextView.text = ""
        for ingredient in recipe.ingredientLines {
            ingredientsTextView.text.append("- \(ingredient)\n")
        }
        _checkIfRecipeAlreadyFavourite()
        _updateFavouriteButtonColor()
    }
    
    private func _checkIfRecipeAlreadyFavourite() {
        if favouriteRecipe == nil {
            do {
                let favouritesRecipes = try CoreDataStack.sharedInstance.viewContext.fetch(FavouriteRecipes.fetchRequest())
                favouritesRecipes.forEach { favourite in
                    if favourite.label == recipe?.label {
                        recipe!.favourite = true
                        favouriteRecipe = favourite
                    }
                }
            } catch {
                print("Error")
            }
        }
    }
    
    /// Update favourite button tint color
    private func _updateFavouriteButtonColor() {
        if let favouvite = recipe?.favourite, favouvite {
            favouriteButton.tintColor = UIColor(named: "Button Background")
        } else {
            favouriteButton.tintColor = UIColor(named: "ClearButtonBackground")
        }
    }
    
    private func _updateDatabase() {
        if let favouvite = recipe?.favourite,
           favouvite {
            _saveRecordOnDatabase()
        } else {
            _deleteRecordOnDatabase()
        }
    }
    
    private func _saveRecordOnDatabase() {
        guard let recipe = recipe else { return }
        let recipeToSave = FavouriteRecipes(context: CoreDataStack.sharedInstance.viewContext)
        recipeToSave.label = recipe.label
        if let url = recipe.image {
            recipeToSave.image = url.absoluteString
        }
        recipeToSave.ingredientLines = recipe.ingredientLines
        recipeToSave.totalTime = Int32(recipe.totalTime)
        recipeToSave.yield = Int16(recipe.yield)
        recipeToSave.ingredients = recipe.ingredients.compactMap {$0.food}
        recipeToSave.isFavourite = true
        
        do {
            try CoreDataStack.sharedInstance.viewContext.save()
        } catch {
            print("We were unable to save \(recipeToSave)")
        }
        favouriteRecipe = recipeToSave
    }
    
    private func _deleteRecordOnDatabase() {
        guard let favouriteRecipe = favouriteRecipe else { return }
        CoreDataStack.sharedInstance.viewContext.delete(favouriteRecipe)
        do {
            try CoreDataStack.sharedInstance.viewContext.save()
        } catch {
            print("We were unavle to delete \(favouriteRecipe)")
        }
        self.favouriteRecipe = nil
    }
}
