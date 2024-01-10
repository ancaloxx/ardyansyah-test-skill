//
//  AlertField.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 05/01/24.
//

import UIKit

class AlertField: UIView {
    
    let labelAlert: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        label.textColor = UIColor.red
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
    
    func layout(result: String) {
        addSubview(labelAlert)
        
        labelAlert.text = result
        labelAlert.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelAlert.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelAlert.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelAlert.widthAnchor.constraint(equalToConstant: 200.0),
            labelAlert.heightAnchor.constraint(equalToConstant: 74.0)
        ])
    }
    
}
