//
//  AlertManager.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 01/06/2022.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()
    
    /// Send an alert view 
    func sendAlert(_ reason: AlertReson, on controller: UIViewController) {
        let alert = UIAlertController(title: "Error", message: reason.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        controller.present(alert, animated: true)
    }
    
    enum AlertReson: String {
        case emptyIngredientList = "Your ingredient list is empty."
        case cannotDownloadRecipe = "Recipes could not be downloaded. Please, try later!"
        case cannotSaveRecipe = "Recipe could not be saved on the database."
        case cannotDeleteRecipe = "Recipe could not be deleted from the database"
        case cannotDownloadFavorite = "The database could not be downloaded!"
    }
}
