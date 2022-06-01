//
//  RecipeManager.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import Alamofire
import CoreData
import Foundation

class RecipeManager {
    // MARK: Public
    // MARK: Properties
    //    var selectedFavouriteRecipe: FavouriteRecipes?
    var selectedRecipe: Recipe?
    var favouriteRecipes: [FavouriteRecipes] { _favouriteRecipes }
    var downloadedRecipes: [Recipe] { _downloadedRecipes }
    var isFavourite: Bool {
        if let favourite = selectedRecipe?.favourite, favourite {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Methods
    /// Download recipe from a list of ingredients
    func getRecipes(forIngredients ingredients: [String], completionHandler: @escaping ((Bool) -> Void)) {
        guard let url = createRequest(withIngredients: ingredients) else {
            completionHandler(false)
            return
        }
        let request = AF.request(url) { $0.timeoutInterval = 10 }.validate()
        
        request.responseDecodable(of: RecipesHits.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success:
                if let hits = response.value  {
                    self._downloadedRecipes = hits.hits.map{$0.recipe}
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            case .failure:
                completionHandler(false)
            }
        }
    }
    
    /// Get recipes from CoreData
    func downloadFavouriteRecipes() {
        let request: NSFetchRequest<FavouriteRecipes> = FavouriteRecipes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavouriteRecipes.label, ascending: true)]
        
        do {
            _favouriteRecipes = try CoreDataStack.sharedInstance.viewContext.fetch(request)
        } catch {
            print("error during download")
        }
    }
    
    func checkIfRecipeIsAlreadyInDatabase() {
        downloadFavouriteRecipes()
        
        if _favouriteRecipes.contains(where: {$0.label == selectedRecipe!.label}) {
            selectedRecipe!.favourite = true
        }
    }
    
    func saveRecordOnDatabase() -> AlertManager.AlertReson? {
        guard let recipe = selectedRecipe else { return nil }
        let recipeToSave = FavouriteRecipes(context: CoreDataStack.sharedInstance.viewContext)
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
        
        do {
            try CoreDataStack.sharedInstance.viewContext.save()
        } catch {
            return .cannotSaveRecipe
        }
        return nil
    }
    
    func deleteRecordOnDatabase() -> AlertManager.AlertReson? {
        guard isFavourite, let favouriteRecipe = _getFavouriteRecord() else { return nil }
        CoreDataStack.sharedInstance.viewContext.delete(favouriteRecipe)
        do {
            try CoreDataStack.sharedInstance.viewContext.save()
        } catch {
            return .cannotDeleteRecipe
        }
        return nil
    }
    
    // MARK: Initialization
    init() {
        downloadFavouriteRecipes()
    }
    
    // MARK: Private
    // MARK: Properties
    private let _url = "https://api.edamam.com/api/recipes/v2?"
    private let _appKey = "70dbd40e1c5f36224bcbe1f10cb51fcb"
    private let _appId = "a86c7669"
    private var _favouriteRecipes: [FavouriteRecipes] = []
    private var _downloadedRecipes: [Recipe] = []
    
    // MARK: Methods
    /// Configure the URL with parameters
    private func createRequest(withIngredients ingredients: [String]) -> URL? {
        let params = ["type": "public", "q": ingredients.joined(separator: ","), "app_id": _appId, "app_key": _appKey]
        
        guard var components = URLComponents(string: _url) else { return nil }
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        return components.url
    }
    
    private func _getFavouriteRecord() -> FavouriteRecipes? {
        return _favouriteRecipes.first(where: {$0.label == selectedRecipe!.label})
    }
}
