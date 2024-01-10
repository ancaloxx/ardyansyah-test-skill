//
//  UITextField+Extension.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 04/01/24.
//

import UIKit

extension UITextField {
    
    func textfieldBorder() {
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 1.0
        
        layer.cornerRadius = 5.0
        backgroundColor = .clear
        
        leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: frame.height))
        leftViewMode = .always
        clipsToBounds = true
    }
    
    func textfieldImage(onClick: Bool) -> UIButton {
        let viewEyes = UIView()
        viewEyes.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: frame.height)
        
        rightView = viewEyes
        rightViewMode = .always
        
        let buttonEyes = UIButton(type: .system)
        buttonEyes.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: frame.height)
        
        let imageEyes = onClick ? UIImage(named: "Component 9_1") : UIImage(named: "Component 8_1")
        buttonEyes.setImage(imageEyes, for: .normal)
        buttonEyes.tintColor = UIColor.black
        
        viewEyes.addSubview(buttonEyes)
        isSecureTextEntry = !onClick
        
        placeholder = onClick ? "password" : "* * * * * *"
        
        return buttonEyes
    }
    
    func textfieldRp() {
        let viewRp = UIView()
        viewRp.frame = CGRect(x: 0.0, y: 0.0, width: 54.0, height: frame.height)
        viewRp.layoutMargins = UIEdgeInsets(top: 0.0, left: -5.0, bottom: 0.0, right: 0.0)
        
        leftView = viewRp
        leftView = viewRp
        leftViewMode = .always
        
        let labelRp: UILabel = {
            let label = UILabel()
            label.text = "Rp"
            label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
            label.textAlignment = .center
            label.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: frame.height)
            label.backgroundColor = .black
            label.textColor = .white
            
            return label
        }()
        
        viewRp.addSubview(labelRp)
    }
    
}
