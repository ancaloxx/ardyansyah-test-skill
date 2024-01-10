//
//  UIView+Extension.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 06/01/24.
//

import UIKit

extension UIView {
    
    func viewShadow() {
        layer.cornerRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5.0
    }
    
    func hideViewShadow() {
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 0.0
    }
    
    func viewBorder() {
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 1.0
    }
    
}
