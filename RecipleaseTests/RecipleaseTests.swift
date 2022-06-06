//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Kevin Bertrand on 18/05/2022.
//

import XCTest
@testable import Reciplease

class RecipleaseTests: XCTestCase {
    private let ingredients = ["lemon", "egg"]
    var recipeManager: RecipeManager!
    var coreDataStack: MockCoreDataStack!
    var fakeNetworkManager: FakeNetworkManager!
    
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        fakeNetworkManager = FakeNetworkManager()
        recipeManager = RecipeManager(networkManager: fakeNetworkManager)
    }
    
    override func tearDown() {
        super.tearDown()
        _ = recipeManager.deleteALlRecordOnDatabase()
    }
    
    // Getting recipes
    func testGivenDownloadRecipe_WhenSuccess_ThenRecipesArrayShouldBeUpdated() {
        // Prepare expectation
        let expectation = XCTestExpectation(description: "Wait for downloading")
        
        // Given
        fakeNetworkManager._status = .correctData
        recipeManager.getRecipes(forIngredients: ingredients) { success in
            // When
            XCTAssertTrue(success)
            
            //Then
            XCTAssertTrue(self.recipeManager.downloadedRecipes.count > 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    func testGivenDownloadRecipe_WhenError_ThenRecipesArrayShouldBeEmpty() {
        // Prepare expectation
        let expectation = XCTestExpectation(description: "Wait for downloading")
        
        // Given
        fakeNetworkManager._status = .incorrectData
        recipeManager.getRecipes(forIngredients: ingredients) { success in
            // When
            XCTAssertFalse(success)
            
            //Then
            XCTAssertTrue(self.recipeManager.downloadedRecipes.count == 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
            
    // Check if recipe is favorite
    func testGivenRecipeIsSelected_WhenRecipeIsFavorite_ThenResultShouldBeTrue() {
        // Given
        _addApplePieToCoreData()
        recipeManager.selectedRecipe = _getApplePieRecipe()
        
        // When
        let isFavorite = recipeManager.selectedRecipeIsFavorite
        
        // Then
        XCTAssertTrue(isFavorite)
    }
    
    func testGivenRecipeIsSelected_WhenRecipeIsNotFavorite_ThenResultShouldBeFalse() {
        // Given
        recipeManager.selectedRecipe = _getApplePieRecipe()
        
        // When
        let isFavorite = recipeManager.selectedRecipeIsFavorite
        recipeManager.reloadFavoriteList()
        
        // Then
        XCTAssertFalse(isFavorite)
    }
    
    // Save record on DB
    func testGivenAddFavorite_WhenTryingToSaveOnCoreData_ThenCoreDataShouldBeUpdated() {
        // Given
        
        // When
        _addApplePieToCoreData()
        
        // Then
        recipeManager.reloadFavoriteList()
        let recipe = recipeManager.favoriteRecipes.first
        XCTAssertEqual("Apple pie", recipe?.label)
    }
    
    func testGivenAddSameFavorite_WhenTryingToSaveOnCoreData_ThenCoreDataShouldNotBeUpdated() {
        // Given
        
        // When
        _addApplePieToCoreData()
        _addApplePieToCoreData()
        
        // Then
        recipeManager.reloadFavoriteList()
        let recipe = recipeManager.favoriteRecipes.first
        XCTAssertEqual("Apple pie", recipe?.label)
        XCTAssertTrue(recipeManager.favoriteRecipes.count == 1)
    }
    
    func testGivenNoneRecipe_WhenTryingToAddNil_ThenGetError() {
        // Given
        recipeManager.selectedRecipe = nil
        
        
        // When
        let error = recipeManager.saveRecordOnDatabase()
        recipeManager.reloadFavoriteList()
        
        // Then
        XCTAssertEqual(recipeManager.favoriteRecipes.count, 0)
        XCTAssertNotNil(error)
    }
    
    // Delete record on DB
    func testGivenRemoveFavorite_WhenTryingToDeleteFromCoreData_ThenFavoriteListShouldBeEmpty() {
        // Given
        _addApplePieToCoreData()
        recipeManager.selectedRecipe = _getApplePieRecipe()
        
        // When
        let error = recipeManager.deleteRecordOnDatabase()
        
        // Then
        XCTAssertEqual(recipeManager.favoriteRecipes.count, 0)
        XCTAssertNil(error)
    }
    
    func testGivenTryingToDeleteFromCoreData_WhenGettingError_ThenFavoriteListShouldNotBeUpdate() {
        // Given
        _addApplePieToCoreData()
        recipeManager.selectedRecipe = _getFrenchFriesRecipe()
        
        // When
        let error = recipeManager.deleteRecordOnDatabase()
        recipeManager.reloadFavoriteList()
        
        // Then
        XCTAssertEqual(recipeManager.favoriteRecipes.first?.label, _getApplePieRecipe().label)
        XCTAssertNotNil(error)
    }
    
    func testGivenNoneSelectedRecipe_WhenTryingToDelete_ThenGetError() {
        // Given
        _addApplePieToCoreData()
        recipeManager.selectedRecipe = nil
        
        // When
        let error = recipeManager.deleteRecordOnDatabase()
        recipeManager.reloadFavoriteList()
        
        // Then
        XCTAssertEqual(recipeManager.favoriteRecipes.count, 1)
        XCTAssertNotNil(error)
    }
    
    
    private func _addApplePieToCoreData() {
        let newRecipe = _getApplePieRecipe()
        recipeManager.selectedRecipe = newRecipe
        _ = recipeManager.saveRecordOnDatabase()
    }
    
    private func _getApplePieRecipe() -> Recipe {
        return Recipe(label: "Apple pie", url: URL(string: "https://www.apple.com"), image:  URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.academiedugout.fr%2Fingredients%2Fpomme_1016&psig=AOvVaw0kxNQeC5dHWwtg93Ma4XfA&ust=1654336613633000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCIC77aOCkfgCFQAAAAAdAAAAABAD"), yield: 3590, ingredientLines: ["3 big apple", "250gr Sugar"], ingredients: [Ingredients(food: "Apple"), Ingredients(food: "Sugar")], totalTime: 45, favorite: true)
    }
    
    private func _getFrenchFriesRecipe() -> Recipe {
        return Recipe(label: "French fries", url: URL(string: "https://www.belgium.be"), image:  URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fbonpourtoi.ca%2Fles-frites-ce-quil-faut-savoir%2F&psig=AOvVaw3y_F67orGdAI7UXZzqxoUn&ust=1654350725463000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCNDG2uy2kfgCFQAAAAAdAAAAABAD"), yield: 3590, ingredientLines: ["3 big potatoes", "4L oil"], ingredients: [Ingredients(food: "Potatoes"), Ingredients(food: "Oil")], totalTime: 45, favorite: false)
    }
}
