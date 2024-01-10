//
//  ViewController.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 04/01/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    private func initialSetup() {
        buttonLoginSetup()
        buttonRegisterSetup()
    }
    
    private func buttonLoginSetup() {
        buttonLogin.layer.cornerRadius = buttonLogin.frame.height / 2.0
    }
    
    private func buttonRegisterSetup() {
        buttonRegister.layer.cornerRadius = buttonRegister.frame.height / 2.0
    }

    @IBAction func buttonLoginAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "loginVC", sender: self)
    }
    
    @IBAction func buttonRegisterAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registerVC", sender: self)
    }
    
}

