//
//  Int+Extension.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 08/01/24.
//

import Foundation

extension Int {
    
    func idrCurrency(price: Int) -> String {
        let numberFormat = NumberFormatter()
        numberFormat.locale = Locale(identifier: "id_ID")
        numberFormat.numberStyle = .currency
        
        return numberFormat.string(from: price as NSNumber) ?? "0"
    }
    
}
