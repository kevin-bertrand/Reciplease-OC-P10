//
//  TextFieldDesign.swift
//  Reciplease
//
//  Created by Kevin Bertrand on 07/06/2022.
//

import UIKit

class TextFieldDesign: UITextField {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
}
