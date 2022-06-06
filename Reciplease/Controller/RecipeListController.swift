//
//  RecipeListController.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import Foundation
import UIKit

class RecipeListController: UIViewController {
    // MARK: Public
    // MARK: Outlet
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet weak var noRecipeFoundView: UIView!
    
    // MARK: Properties
    var recipeManager = RecipeManager()
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _delegateSetup()
        _dataSourceSetup()
        _checkIfRecipesWereFound()
    }
    
    // MARK: Methods
    /// Prepare the segue to pass data to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == _segueToDetails, let detailViewVC = segue.destination as? DetailViewController else { return }
        detailViewVC.recipeManager = recipeManager
    }
    
    /// Get selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeManager.selectedRecipe = recipeManager.downloadedRecipes[indexPath.row]
        performSegue(withIdentifier: _segueToDetails, sender: self)
    }
    
    // MARK: Private
    // MARK: Properties
    private let _segueToDetails = "segueToDetails"
    private var _selectedRecipe: Recipe?
    
    // MARK: Methods
    private func _checkIfRecipesWereFound() {
        if recipeManager.downloadedRecipes.count == 0 {
            noRecipeFoundView.isHidden = false
        }
    }
}


// MARK: Delegate extension
extension RecipeListController: UITableViewDelegate {
    // MARK: Private method
    /// Setup the delegate
    private func _delegateSetup() {
        recipeTableView.delegate = self
    }
}

// MARK: Data source extension
extension RecipeListController: UITableViewDataSource {
    // MARK: Public method
    /// Set the number of row of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeManager.downloadedRecipes.count
    }
    
    /// Configure each cells of the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell to reuse
        guard let recipeCell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCellView else {
            return UITableViewCell()
        }
        
        recipeCell.configure(withRecipe: recipeManager.downloadedRecipes[indexPath.row])
        
        return recipeCell
    }
    
    // MARK: Private method
    /// Setup the source of data
    private func _dataSourceSetup() {
        recipeTableView.dataSource = self
    }
}
