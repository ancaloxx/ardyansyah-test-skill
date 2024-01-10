//
//  UIButton+Extension.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 06/01/24.
//

import UIKit

extension UIButton {
    
    func buttonBorder(color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
    }
    
}
