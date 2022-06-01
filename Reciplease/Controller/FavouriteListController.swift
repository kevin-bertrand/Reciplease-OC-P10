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
    
    // MARK: Properties
    
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        _downloadRecipes()
        _delegateSetup()
        _dataSourceSetup()
    }
    
    // MARK: Methods
    /// Prepare the segue to pass data to next view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == _segueToDetails, let detailViewVC = segue.destination as? DetailViewController else { return }
        detailViewVC.recipe = _selectedRecipe
    }
    
    /// Get selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectedRecipe = _recipeList[indexPath.row]
        performSegue(withIdentifier: _segueToDetails, sender: self)
    }
    
    // MARK: Private
    // MARK: Properties
    private let _segueToDetails = "segueFromFavouriteToDetail"
    private var _selectedRecipe: RecipeInformations?
    private let _recipeManager = RecipeManager()
    private var _recipeList: [RecipeInformations] = []
    
    // MARK: Method
    /// Get recipes from CoreData
    private func _downloadRecipes() {
        let request: NSFetchRequest<FavouriteRecipes> = FavouriteRecipes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavouriteRecipes.label, ascending: true)]
        
        do {
            let recipes = try CoreDataStack.sharedInstance.viewContext.fetch(request)
            
            for recipe in recipes {
                _recipeList.append(RecipeInformations(label: recipe.label ?? "",
                                                      image: URL(string: recipe.image ?? ""),
                                                      yield: Int(recipe.yield),
                                                      ingredientLines: recipe.ingredientLines ?? [],
                                                      totalTime: Int(recipe.totalTime),
                                                      favourite: true))
            }
            
        } catch {
            print("error during download")
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
