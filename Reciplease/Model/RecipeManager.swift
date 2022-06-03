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
    var selectedRecipe: Recipe? {
        didSet {
            if let recipe = selectedRecipe, _coreDataManager.checkIfRecipeIsFavorite(recipe) {
                selectedRecipe!.favourite = true
            }
        }
    }
    var favouriteRecipes: [Recipe] {
        return _coreDataManager.favorites
    }
    var downloadedRecipes: [Recipe] { _downloadedRecipes }
    var selectedRecipeIsFavourite: Bool {
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
    
    /// Save the record on the database
    func saveRecordOnDatabase() -> AlertManager.AlertReson? {
        guard let recipe = selectedRecipe else { return .cannotSaveRecipe }
        
        if _coreDataManager.addRecipe(recipe) {
            selectedRecipe!.favourite = true
            return nil
        } else {
            return .cannotSaveRecipe
        }
    }
    
    /// Delete the record from the database
    func deleteRecordOnDatabase() -> AlertManager.AlertReson? {
        guard let selectedRecipe = selectedRecipe else { return .cannotDeleteRecipe }

        if _coreDataManager.deleteRecipe(selectedRecipe) {
            return nil
        } else {
            return .cannotDeleteRecipe
        }
    }
    
    func reloadFavoriteList() {
        _coreDataManager.reloadFavoriteList()
    }
    
    // MARK: Initialization
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        _coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }
    
    // MARK: Private
    // MARK: Properties
    private let _url = "https://api.edamam.com/api/recipes/v2?"
    private let _appKey = "70dbd40e1c5f36224bcbe1f10cb51fcb"
    private let _appId = "a86c7669"
    private var _downloadedRecipes: [Recipe] = []
    private let _coreDataManager: CoreDataManager
    
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
}
