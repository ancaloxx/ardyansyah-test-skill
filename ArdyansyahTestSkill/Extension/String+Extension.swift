//
//  String+Extension.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 05/01/24.
//

import Foundation

extension String {
    
    func getEmailValidation(email: String) -> String {
        var error = ""
        
        if !NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email) {
            error = "The email field not valid"
        }
        
        if email.isEmpty {
            error = "The email field required"
        }
        
        return error
    }
    
    func getPasswordValidation(password: String) -> [String] {
        var error = [String]()
        
        if !NSPredicate(format: "SELF MATCHES %@", uppercaseRegEx).evaluate(with: password) {
            error.append("last one uppercase")
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", symbolRegEx).evaluate(with: password) {
            error.append("last one symbol")
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", lowercaseRegEx).evaluate(with: password) {
            error.append("last one lowercase")
        }
        
        if password.count < 6 {
            error.append("required 6 character")
        }
        
        if password.isEmpty {
            error.removeAll()
            error.append("The password field required")
        }
        
        return error
    }
    
    func getNameProductValidation(nameProduct: String) -> String {
        var error = ""
        
        if nameProduct.count >= 200 {
            error = "Maximum 200 character"
        }
        
        if nameProduct.isEmpty {
            error = "The name product field required"
        }
        
        return error
    }
    
    func getDescriptionValidation(description: String) -> String {
        var error = ""
        
        if description.count >= 500 {
            error = "Maximum 500 character"
        }
        
        if description.isEmpty {
            error = "The description field required"
        }
        
        return error
    }
    
    func removeMimeType(imageStr: String) -> String {
        let imageStrArray = imageStr.components(separatedBy: ",")
        let result = imageStrArray[1]
        
        return result
    }
    
}
