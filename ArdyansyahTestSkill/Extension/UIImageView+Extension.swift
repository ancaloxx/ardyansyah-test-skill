//
//  UIImageView.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 09/01/24.
//

import UIKit

extension UIImageView {
    
    func loadImage(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        
        image = nil
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}
