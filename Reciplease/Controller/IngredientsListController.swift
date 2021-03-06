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
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _delegateSetup()
        _dataSourceSetup()
    }
    
    // MARK: Actions
    @IBAction func addIngredientButtonTouched() {
        _addIngredient()
    }
    
    @IBAction func clearListButtonTouched() {
        _ingredients = []
        ingredientTableView.reloadData()
    }
    
    @IBAction func searchRecipeButtonTouched() {
        // Check if the list is filled
        guard !_ingredients.isEmpty else {
            AlertManager.shared.sendAlert(.emptyIngredientList, on: self)
            return
        }
        
        loadingView.isHidden = false
        
        // Download recipes
        _recipeManager.getRecipes(forIngredients: _ingredients) { [weak self] isSuccess in
            guard let self = self else { return }
            self.loadingView.isHidden = true
            self._ingredients = []
            self.ingredientTableView.reloadData()
            if isSuccess {
                self.performSegue(withIdentifier: self._segueToRecipeList, sender: self)
            } else {
                AlertManager.shared.sendAlert(.cannotDownloadRecipe, on: self)
            }
        }
    }
    
    // MARK: Methods
    /// Prepare the segue to pass data to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == _segueToRecipeList, let recipeListVC = segue.destination as? RecipeListController else { return }
        recipeListVC.recipeManager = _recipeManager
    }
    
    // MARK: Private
    // MARK: Properties
    private var _ingredients: [String] = []
    private let _segueToRecipeList = "segueToRecipeList"
    private let _recipeManager = RecipeManager()
    
    // MARK: Method
    private func _addIngredient() {
        self.view.endEditing(true)
        guard let ingredient = ingredientTextField.text, !ingredient.isEmpty else { return }
        
        _ingredients.append(ingredient)
        ingredientTableView.reloadData()
        ingredientTextField.text = ""
    }
}

// MARK: Delegate extension
extension IngredientListController: UITableViewDelegate, UITextFieldDelegate  {
    // MARK: Private method
    /// Setup the delegate
    private func _delegateSetup() {
        ingredientTableView.delegate = self
        ingredientTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _addIngredient()
        return false
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
