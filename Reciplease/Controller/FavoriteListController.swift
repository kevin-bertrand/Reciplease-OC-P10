//
//  FavoriteListController.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 31/05/2022.
//

import Foundation
import UIKit
import CoreData

class FavoriteListController: UIViewController {
    // MARK: Public
    // MARK: Outlet
    @IBOutlet weak var favoriteRecipeTableView: UITableView!
    @IBOutlet weak var noFavoriteView: UIView!
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _downloadRecipes()
        _delegateSetup()
        _dataSourceSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _downloadRecipes()
    }
    
    // MARK: Methods
    /// Prepare the segue to pass data to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == _segueToDetails, let detailViewVC = segue.destination as? DetailViewController else { return }
        detailViewVC.recipeManager = _recipeManager
    }
    
    /// Get selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _recipeManager.selectedRecipe = _recipeManager.favoriteRecipes[indexPath.row]
        performSegue(withIdentifier: _segueToDetails, sender: self)
    }
    
    // MARK: Private
    // MARK: Properties
    private let _segueToDetails = "segueFromFavoriteToDetail"
    private let _recipeManager = RecipeManager()
    
    // MARK: Method
    /// Get recipes from CoreData
    private func _downloadRecipes() {
        _recipeManager.reloadFavoriteList()
        
        if _recipeManager.favoriteRecipes.count == 0 {
            noFavoriteView.isHidden = false
        } else {
            noFavoriteView.isHidden = true
        }
        favoriteRecipeTableView.reloadData()
    }
}

// MARK: Delegate extension
extension FavoriteListController: UITableViewDelegate {
    // MARK: Private method
    /// Setup the delegate
    private func _delegateSetup() {
        favoriteRecipeTableView.delegate = self
    }
}

// MARK: Data source extension
extension FavoriteListController: UITableViewDataSource {
    // MARK: Public method
    /// Set the number of row of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _recipeManager.favoriteRecipes.count
    }
    
    /// Configure each cells of the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Get cell to reuse
        guard let recipeCell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCellView else {
            return UITableViewCell()
        }
        
        recipeCell.configure(withRecipe: _recipeManager.favoriteRecipes[indexPath.row])
        
        return recipeCell
    }
    
    // MARK: Private method
    /// Setup the source
    private func _dataSourceSetup() {
        favoriteRecipeTableView.dataSource = self
    }
}
