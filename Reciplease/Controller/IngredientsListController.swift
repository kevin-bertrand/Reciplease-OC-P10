//
//  IngredientsListController.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import Foundation
import UIKit

class IngredientListController: UIViewController {
    // MARK: Public
    // MARK: Outlets
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _delegateSetup()
        _dataSourceSetup()
    }
    
    // MARK: Actions
    @IBAction func addIngredientButtonTouched() {
        guard let ingredient = ingredientTextField.text, !ingredient.isEmpty else { return }
        
        _ingredients.append(ingredient)
        ingredientTableView.reloadData()
        ingredientTextField.text = ""
    }
    
    @IBAction func clearListButtonTouched() {
        _ingredients = []
        ingredientTableView.reloadData()
    }
    
    @IBAction func searchRecipeButtonTouched() {
        // Check if the list is filled
        guard !_ingredients.isEmpty else {
            showAlert()
            return
        }
        
        // Download recipes
        _recipeManager.getRecipes(forIngredients: _ingredients) { data in
            if let data = data {
                self._recipes = data
                self.performSegue(withIdentifier: self._segueToRecipeList, sender: self)
            }
        }
    }
    
    // MARK: Methods
    /// Prepare the segue to pass data to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == _segueToRecipeList, let recipeListVC = segue.destination as? RecipeListController else { return }
        recipeListVC.recipeList = _recipes
    }
    
    // MARK: Private
    // MARK: Properties
    private var _ingredients: [String] = []
    private let _segueToRecipeList = "segueToRecipeList"
    private let _recipeManager = RecipeManager()
    private var _recipes: [Recipe] = []
    
    // MARK: Methods
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Your ingredient list is empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

// MARK: Delegate extension
extension IngredientListController: UITableViewDelegate  {
    // MARK: Private method
    /// Setup the delegate
    private func _delegateSetup() {
        ingredientTableView.delegate = self
    }
}

// MARK: Data source extension
extension IngredientListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell to reuse
        guard let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? IngredientCellView else {
            return UITableViewCell()
        }
        
        ingredientCell.configure(withIngredient: _ingredients[indexPath.row])
        
        return ingredientCell
    }
    
    // MARK: Private method
    /// Setup the source of data
    private func _dataSourceSetup() {
        ingredientTableView.dataSource = self
    }
}
