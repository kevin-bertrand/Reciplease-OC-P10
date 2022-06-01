//
//  RecipeManager.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import Alamofire
import Foundation

class RecipeManager {
    // MARK: Public
    // MARK: Properties
    
    // MARK: Methods
    func getRecipes(forIngredients ingredients: [String], completionHandler: @escaping (([RecipeInformations]?) -> Void)) {
        guard let url = createRequest(withIngredients: ingredients) else {
            completionHandler(nil)
            return
        }
        let request = AF.request(url) { $0.timeoutInterval = 10 }.validate()
        
        request.responseDecodable(of: RecipesHits.self) { response in
            switch response.result {
            case .success:
                guard let hits = response.value else {
                    completionHandler(nil)
                    return
                }
                completionHandler(hits.hits.map{$0.recipe})
            case .failure:
                completionHandler(nil)
            }
        }
    }
    
    func getFavourites() -> [RecipeInformations] {
        return _downloadFavouriteRecipes().sorted(by: {$0.label < $1.label })
    }
    
    // MARK: Private
    // MARK: Properties
    private let _url = "https://api.edamam.com/api/recipes/v2?"
    private let _appKey = "70dbd40e1c5f36224bcbe1f10cb51fcb"
    private let _appId = "a86c7669"
    
    // MARK: Methods
    private func createRequest(withIngredients ingredients: [String]) -> URL? {
        let params = ["type": "public", "q": ingredients.joined(separator: ","), "app_id": _appId, "app_key": _appKey]
        
        guard var components = URLComponents(string: _url) else { return nil }
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in params {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        return components.url
    }
    
    private func _downloadFavouriteRecipes() -> [RecipeInformations] {
        return []
    }
}
