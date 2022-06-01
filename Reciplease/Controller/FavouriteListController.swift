//
//  FavouriteListController.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 31/05/2022.
//

import Foundation
import UIKit
import CoreData

class FavouriteListController: UIViewController {
    // MARK: Public
    // MARK: Outlet
    @IBOutlet weak var favouriteRecipeTableView: UITableView!
    @IBOutlet weak var noFavouriteView: UIView!
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _delegateSetup()
        _dataSourceSetup()
        _downloadRecipes()
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
        _recipeManager.selectedRecipe = _recipeList[indexPath.row]
        print(_recipeList[indexPath.row])
        performSegue(withIdentifier: _segueToDetails, sender: self)
    }
    
    // MARK: Private
    // MARK: Properties
    private let _segueToDetails = "segueFromFavouriteToDetail"
    private let _recipeManager = RecipeManager()
    private var _selectedRecipe: FavouriteRecipes?
    private var _recipeList: [Recipe] {
        get{
            _recipeManager.favouriteRecipes.map {
                Recipe(label: $0.label ?? "",
                                   url: URL(string: $0.url ?? ""),
                                   image: URL(string: $0.image ?? ""),
                                   yield: Int($0.yield),
                                   ingredientLines: $0.ingredientLines ?? [],
                                   ingredients: $0.ingredients?.compactMap({ ingredient in Ingredients(food: ingredient)}) ?? [],
                                   totalTime: Int($0.totalTime),
                                   favourite: true)
            }
        }
    }
    
    // MARK: Method
    /// Get recipes from CoreData
    private func _downloadRecipes() {
        _recipeManager.downloadFavouriteRecipes()
        
        if _recipeManager.favouriteRecipes.count == 0 {
            noFavouriteView.isHidden = false
        } else {
            noFavouriteView.isHidden = true
        }
    }
}

// MARK: Delegate extension
extension FavouriteListController: UITableViewDelegate {
    // MARK: Private method
    /// Setup the delegate
    private func _delegateSetup() {
        favouriteRecipeTableView.delegate = self
    }
}

// MARK: Data source extension
extension FavouriteListController: UITableViewDataSource {
    // MARK: Public method
    /// Set the number of row of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        _recipeList.count
    }
    
    /// Configure each cells of the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Get cell to reuse
        guard let recipeCell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeCellView else {
            return UITableViewCell()
        }
        
        recipeCell.configure(withRecipe: _recipeList[indexPath.row])
        
        return recipeCell
    }
    
    // MARK: Private method
    /// Setup the source
    private func _dataSourceSetup() {
        favouriteRecipeTableView.dataSource = self
    }
}
