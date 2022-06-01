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
        guard segue.identifier == _segueToDetails, let detailViewVC = segue.destination as? DetailViewController, let selectedRecipe = _selectedRecipe else { return }
        detailViewVC.recipe = RecipeInformations(label: selectedRecipe.label ?? "",
                                                 image: URL(string: selectedRecipe.image ?? ""),
                                                 yield: Int(selectedRecipe.yield),
                                                 ingredientLines: selectedRecipe.ingredientLines ?? [],
                                                 totalTime: Int(selectedRecipe.totalTime),
                                                 favourite: true)
        detailViewVC.favouriteRecipe = selectedRecipe
    }
    
    /// Get selected cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _selectedRecipe = _favouriteRecipesList[indexPath.row]
        performSegue(withIdentifier: _segueToDetails, sender: self)
    }
    
    // MARK: Private
    // MARK: Properties
    private let _segueToDetails = "segueFromFavouriteToDetail"
    private var _selectedRecipe: FavouriteRecipes?
    private let _recipeManager = RecipeManager()
    private var _favouriteRecipesList: [FavouriteRecipes] = []
    private var _recipeList: [RecipeInformations] {
        get{
            _favouriteRecipesList.map {
                RecipeInformations(label: $0.label ?? "",
                                   image: URL(string: $0.image ?? ""),
                                   yield: Int($0.yield),
                                   ingredientLines: $0.ingredientLines ?? [],
                                   totalTime: Int($0.totalTime),
                                   favourite: true)
            }
        }
    }
    
    // MARK: Method
    /// Get recipes from CoreData
    private func _downloadRecipes() {
        let request: NSFetchRequest<FavouriteRecipes> = FavouriteRecipes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavouriteRecipes.label, ascending: true)]
        
        do {
            _favouriteRecipesList = try CoreDataStack.sharedInstance.viewContext.fetch(request)
            favouriteRecipeTableView.reloadData()
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
