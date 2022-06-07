//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 03/06/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: Public
    // MARK: Initialization
    init() {}
    
    // MARK: Properties
    var favorites: [Recipe] = []
    
    // MARK: Methods
    /// Delete a specific recipe from the database
    func deleteRecipe(_ recipe: Recipe) -> Bool {
        let request: NSFetchRequest<FavoriteRecipes> = FavoriteRecipes.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", recipe.label)
        request.predicate = NSPredicate(format: "url == %@", recipe.url?.absoluteString ?? "")
        
        if let favorites = try? _mainContext.fetch(request) {
            favorites.forEach { _mainContext.delete($0) }
        }
        return _coreDataStack.saveContext()
    }
    
    /// Delete all the favorite recipes from the database
    func deleteAllRecipe() -> Bool {
        let request: NSFetchRequest<FavoriteRecipes> = FavoriteRecipes.fetchRequest()
        
        if let favorites = try? _mainContext.fetch(request) {
            favorites.forEach {_mainContext.delete($0)}
        }
        return _coreDataStack.saveContext()
    }
    
    /// Add a new recipe to the favorite database
    func addRecipe(_ recipe: Recipe) -> Bool {
        guard !checkIfRecipeIsFavorite(recipe) else { return false }
        
        let recipeToSave = FavoriteRecipes(context: _mainContext)
        recipeToSave.label = recipe.label
        if let url = recipe.image {
            recipeToSave.image = url.absoluteString
        }
        recipeToSave.ingredientLines = recipe.ingredientLines
        recipeToSave.totalTime = Int32(recipe.totalTime)
        recipeToSave.yield = Int16(recipe.yield)
        recipeToSave.ingredients = recipe.ingredients.compactMap {$0.food}
        recipeToSave.isFavorite = true
        recipeToSave.url = recipe.url?.absoluteString
        
        return _coreDataStack.saveContext()
    }
    
    /// Check if a specific recipe is already on the favorite database
    func checkIfRecipeIsFavorite(_ recipe: Recipe) -> Bool {
        let request: NSFetchRequest<FavoriteRecipes> = FavoriteRecipes.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", recipe.label)
        request.predicate = NSPredicate(format: "url == %@", recipe.url?.absoluteString ?? "")
        
        guard let countInstances = try? _mainContext.count(for: request), countInstances != 0 else { return false }
        return true
    }
    
    /// Reload all the favorite list
    func reloadFavoriteList() {
        let request: NSFetchRequest<FavoriteRecipes> = FavoriteRecipes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteRecipes.label, ascending: true)]
        
        do {
            let favoriteRecipes = try _mainContext.fetch(request)
            favorites = favoriteRecipes.map { favorite in
                Recipe(label: favorite.label!,
                       url: URL(string: favorite.url ?? ""),
                       image: URL(string: favorite.image ?? ""),
                       yield: Int(favorite.yield),
                       ingredientLines: favorite.ingredientLines!,
                       ingredients: (favorite.ingredients?.map({ ingredient in
                    Ingredients(food: ingredient)
                }))!,
                       totalTime: Int(favorite.totalTime),
                       favorite: true)
            }
        } catch {
            favorites = []
        }
    }
    
    /// Call the CoreData stack to save the context
    func saveContext() {
        _ = _coreDataStack.saveContext()
    }
    
    // MARK: Private
    // MARK: Properties
    private let _coreDataStack = CoreDataStack()
    private var _mainContext: NSManagedObjectContext {
        return CoreDataStack.mainContext
    }
}
