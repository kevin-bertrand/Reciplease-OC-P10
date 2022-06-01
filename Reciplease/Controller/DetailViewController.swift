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
        }
        plateNameLabel.text = recipe.label
        yieldLabel.text = "\(recipe.yield) 👍"
        timeLabel.text = "\(recipe.totalTime.formatToStringTime) 🕓"
        
        ingredientsTextView.text = ""
        for ingredient in recipe.ingredientLines {
            ingredientsTextView.text.append("- \(ingredient)\n")
        }
        _updateFavouriteButtonColor()
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
        if let recipe = recipe,
           let favouvite = recipe.favourite,
           favouvite {
            let recipeToSave = FavouriteRecipes(context: CoreDataStack.sharedInstance.viewContext)
            recipeToSave.label = recipe.label
            if let url = recipe.image {
                recipeToSave.image = url.absoluteString
            }
            recipeToSave.ingredientLines = recipe.ingredientLines
            recipeToSave.totalTime = Int32(recipe.totalTime)
            recipeToSave.yield = Int16(recipe.yield)
            recipeToSave.isFavourite = true
            
            do {
                try CoreDataStack.sharedInstance.viewContext.save()
            } catch {
                print("We were unable to save \(recipeToSave)")
            }
        } else {
            
        }
    }
}
