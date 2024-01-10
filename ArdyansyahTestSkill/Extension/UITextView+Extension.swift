//
//  UITextView+Extension.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 06/01/24.
//

import UIKit

extension UITextView {
    
    func textviewBorder() {
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        backgroundColor = .clear
        
        contentInset = UIEdgeInsets(top: 0.0, left: 4.0, bottom: 0.0, right: 0.0)
    }
    
    func textviewPlaceholder() {
        text = "description product"
        textColor = .systemGray3
    }
    
}
