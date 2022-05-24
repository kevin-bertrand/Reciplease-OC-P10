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
    @IBOutlet weak var timeLabel :UILabel!
    
    // MARK: Properties
    var recipe: Recipe?
    
    // MARK: Outlets
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _configureView()
    }
    
    // MARK: Action
    
    // MARK: Private
    // MARK: Properties
    
    // MARK: Methods
    /// Configure the view when it is shown
    private func _configureView() {
        guard let recipe = recipe else { return }
        
        plateImage.dowloadFrom(recipe.image)
        plateNameLabel.text = recipe.label
        yieldLabel.text = "\(recipe.yield) 👍"
        timeLabel.text = "\(recipe.totalTime.formatToStringTime) 🕓"
        
        ingredientsTextView.text = ""
        for ingredient in recipe.ingredientLines {
            ingredientsTextView.text.append("- \(ingredient)\n")
        }        
    }
}
