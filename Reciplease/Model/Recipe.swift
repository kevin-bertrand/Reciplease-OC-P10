//
//  Recipe.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import Foundation

struct RecipesHits: Codable {
    let hits: [Hit]
}

struct Hit: Codable {
    let recipe: RecipeInformations
}

struct RecipeInformations: Codable {
    let label: String
    let image: URL?
    let yield: Int
    let ingredientLines: [String]
    let ingredients: [Ingredients]
    let totalTime: Int
    var favourite: Bool?
}

struct Ingredients: Codable {
    let food: String
}
