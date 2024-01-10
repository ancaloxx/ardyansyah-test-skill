//
//  IndicatorRunning.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 05/01/24.
//

import UIKit

class IndicatorRunning: UIView {
    
    var blurEffectView = UIVisualEffectView()
    let indicatorActivity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
    
    func layout() {
        blurEffectSetup()
        indicatorActivitySetup()
        labelSetup()
    }
    
    func blurEffectSetup() {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        blurEffectView.effect = blurEffect
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(blurEffectView)
    }
    
    func indicatorActivitySetup() {
        addSubview(indicatorActivity)
        
        indicatorActivity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorActivity.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor),
            indicatorActivity.centerYAnchor.constraint(equalTo: blurEffectView.centerYAnchor)
        ])
    }
    
    func labelSetup() {
        let labelText: UILabel = {
           let label = UILabel()
            label.text = "waiting..."
            label.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
            label.textAlignment = .center
            
            return label
        }()
        
        addSubview(labelText)
        
        labelText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelText.centerXAnchor.constraint(equalTo: blurEffectView.centerXAnchor),
            labelText.topAnchor.constraint(equalTo: indicatorActivity.bottomAnchor, constant: 32.0)
        ])
    }
    
}
