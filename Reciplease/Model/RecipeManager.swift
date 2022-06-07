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
                selectedRecipe!.favorite = true
            }
        }
    }
    var favoriteRecipes: [Recipe] {
        return _coreDataManager.favorites
    }
    var downloadedRecipes: [Recipe] { _downloadedRecipes }
    var selectedRecipeIsFavorite: Bool {
        guard let recipe = selectedRecipe else { return false }
        return _coreDataManager.checkIfRecipeIsFavorite(recipe)
    }
    
    // MARK: Methods
    /// Download recipe from a list of ingredients
    func getRecipes(forIngredients ingredients: [String], completionHandler: @escaping ((Bool) -> Void)) {
        guard let url = _createRequest(withIngredients: ingredients) else {
            completionHandler(false)
            return
        }
        
        _networkManager.request(url: url) { [weak self] response in
            guard let self = self else { return }
            var isASuccess = false
            switch response.result {
            case .success:
                if let hits = response.value  {
                    self._downloadedRecipes = hits.hits.map{$0.recipe}
                    isASuccess = true
                }
            case .failure:
                break
            }
            
            completionHandler(isASuccess)
        }
    }
    
    /// Save the record on the database
    func saveRecordOnDatabase() -> AlertManager.AlertReson? {
        guard let recipe = selectedRecipe else { return .cannotSaveRecipe }
        
        var alert: AlertManager.AlertReson? = nil
        
        if _coreDataManager.addRecipe(recipe) {
            selectedRecipe!.favorite = true
        } else {
            alert = .cannotSaveRecipe
        }
        
        return alert
    }
    
    /// Delete the record from the database
    func deleteRecordOnDatabase() -> AlertManager.AlertReson? {
        guard let selectedRecipe = selectedRecipe else { return .cannotDeleteRecipe }

        return _coreDataManager.deleteRecipe(selectedRecipe) ?  nil : .cannotDeleteRecipe
    }
    
    /// Delete all records
    func deleteALlRecordOnDatabase() -> AlertManager.AlertReson? {
        var alert: AlertManager.AlertReson? = nil
        
        if !_coreDataManager.deleteAllRecipe() {
            alert = .cannotDeleteRecipe
        }
        
        return alert
    }
    
    /// Reload the favorite list
    func reloadFavoriteList() {
        _coreDataManager.reloadFavoriteList()
    }
    
    init(networkManager: NetworkManager = NetworkManager()) {
        _networkManager = networkManager
    }
    
    // MARK: Private
    // MARK: Properties
    private let _url = "https://api.edamam.com/api/recipes/v2?"
    private let _appKey = "70dbd40e1c5f36224bcbe1f10cb51fcb"
    private let _appId = "a86c7669"
    private var _downloadedRecipes: [Recipe] = []
    private let _coreDataManager = CoreDataManager()
    private var _networkManager: NetworkManager
    
    // MARK: Methods
    /// Configure the URL with parameters
    private func _createRequest(withIngredients ingredients: [String]) -> URL? {
        let params = ["type": "public", "q": ingredients.joined(separator: ","), "app_id": _appId, "app_key": _appKey]
        
        guard var components = URLComponents(string: _url) else { return nil }
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        return components.url
    }
}
