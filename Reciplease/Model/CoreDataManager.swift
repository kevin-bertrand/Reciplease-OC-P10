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
    init(coreDataStack: CoreDataStack) {
        _coreDataStack = coreDataStack
    }
    
    // MARK: Properties
    var favorites: [Recipe] = []
    
    // MARK: Methods
    func deleteRecipe(_ recipe: Recipe) -> Bool {
        let request: NSFetchRequest<FavouriteRecipes> = FavouriteRecipes.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", recipe.label)
        request.predicate = NSPredicate(format: "url == %@", recipe.url?.absoluteString ?? "" )
        
        if let favorites = try? _mainContext.fetch(request) {
            favorites.forEach { _mainContext.delete($0) }
        }
        return _coreDataStack.saveContext()
    }
    
    func addRecipe(_ recipe: Recipe) -> Bool {
        let recipeToSave = FavouriteRecipes(context: _mainContext)
        recipeToSave.label = recipe.label
        if let url = recipe.image {
            recipeToSave.image = url.absoluteString
        }
        recipeToSave.ingredientLines = recipe.ingredientLines
        recipeToSave.totalTime = Int32(recipe.totalTime)
        recipeToSave.yield = Int16(recipe.yield)
        recipeToSave.ingredients = recipe.ingredients.compactMap {$0.food}
        recipeToSave.isFavourite = true
        recipeToSave.url = recipe.url?.absoluteString
        
        return _coreDataStack.saveContext()
    }
    
    func checkIfRecipeIsFavorite(_ recipe: Recipe) -> Bool {
        let request: NSFetchRequest<FavouriteRecipes> = FavouriteRecipes.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", recipe.label)
        request.predicate = NSPredicate(format: "url == %@", recipe.url?.absoluteString ?? "" )
        
        guard let countInstances = try? _mainContext.count(for: request), countInstances != 0 else { return false }
        return true
    }
    
    func reloadFavoriteList() {
        let request: NSFetchRequest<FavouriteRecipes> = FavouriteRecipes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavouriteRecipes.label, ascending: true)]
        
        do {
            let favouriteRecipes = try _mainContext.fetch(request)
            favorites = favouriteRecipes.map { favorite in
                Recipe(label: favorite.label ?? "",
                       url: URL(string: favorite.url ?? ""),
                       image: URL(string: favorite.image ?? ""),
                       yield: Int(favorite.yield),
                       ingredientLines: favorite.ingredientLines ?? [],
                       ingredients: favorite.ingredients?.map({ ingredient in
                            Ingredients(food: ingredient)
                        }) ?? [],
                       totalTime: Int(favorite.totalTime),
                       favourite: true)
            }
        } catch {
            favorites = []
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let _coreDataStack: CoreDataStack
    private var _mainContext: NSManagedObjectContext {
        CoreDataStack.mainContext
    }
}
