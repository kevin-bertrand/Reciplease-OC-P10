//
//  Int.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 24/05/2022.
//

import Foundation

extension Int {
    /// Formatting an integer (in minutes) in time
    var formatToStringTime: String {
        if self <= 0 {
            return "N/A"
        } else {
            let minutes = self % 60
            let hours = self / 60
            
            if hours == 0 {
                return "\(minutes)min"
            } else if minutes == 0 {
                return "\(hours)h"
            } else {
                return "\(hours)h \(minutes)min"
            }
        }
    }
}
