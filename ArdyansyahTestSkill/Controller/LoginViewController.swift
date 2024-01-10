//
//  LoginViewController.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 04/01/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    
    private let alertField = AlertField()
    private var indicatorRunning = IndicatorRunning()
    
    private var onClick = false
    private var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    private func initialSetup() {
        navigationBarSetup()
        textfieldEmailSetup()
        textfieldPasswordSetup()
        buttonLoginSetup()
    }
    
    private func navigationBarSetup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Component 14_1"), style: .plain, target: self, action: #selector(navigationBack))
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc private func navigationBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func textfieldEmailSetup() {
        textfieldEmail.textfieldBorder()
        textfieldEmail.placeholder = "johndoe@sample.com"
        
        textfieldEmail.delegate = self
        textfieldEmail.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    private func textfieldPasswordSetup() {
        textfieldPassword.textfieldBorder()
        textfieldPassword.textfieldImage(onClick: onClick).addTarget(self, action: #selector(onClickEyes), for: .touchUpInside)
        
        textfieldPassword.delegate = self
        textfieldPassword.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    @objc func changeText() {
        alertField.removeFromSuperview()
    }
    
    @objc private func onClickEyes() {
        onClick = !onClick
        textfieldPassword.textfieldImage(onClick: onClick).addTarget(self, action: #selector(onClickEyes), for: .touchUpInside)
    }
    
    private func buttonLoginSetup() {
        buttonLogin.layer.cornerRadius = buttonLogin.frame.height / 2.0
    }
    
    @IBAction func buttonLoginAction(_ sender: UIButton) {
        let email = textfieldEmail.text ?? ""
        let password = textfieldPassword.text ?? ""
        let login = Login(email: email, password: password)
        
        if email.getEmailValidation(email: email).isEmpty {
            if !password.isEmpty {
                showIndicatorRunning()
                
                APIManager.shareInstance.callingLoginAPI(login: login) { result in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        let code = result["code"] as? String ?? ""
                        let message = result["message"] as? String ?? ""
                        self.key = (result["data"] as AnyObject)["token"] as? String ?? ""
                        
                        if code == "20000" {
                            self.performSegue(withIdentifier: "listproductVC", sender: self)
                            self.navigationController?.navigationBar.isHidden = false
                        } else {
                            self.navigationController?.navigationBar.isHidden = false
                            
                            self.indicatorRunning.removeFromSuperview()
                            self.showAlertField(result: message)
                        }
                    }
                }
            } else {
                showAlertField(result: "The password field required")
            }
        } else {
            let emailError = email.getEmailValidation(email: email)
            showAlertField(result: emailError)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ListProductViewController {
            vc.key = key
        }
    }
    
    private func showAlertField(result: String) {
        view.addSubview(alertField)
        
        alertField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertField.bottomAnchor.constraint(equalTo: buttonLogin.topAnchor, constant: -32.0),
            alertField.widthAnchor.constraint(equalToConstant: view.frame.width - 64.0),
            alertField.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        alertField.layout(result: result)
    }
    
    private func showIndicatorRunning() {
        navigationController?.navigationBar.isHidden = true
        
        indicatorRunning = IndicatorRunning(frame: view.frame)
        view.addSubview(indicatorRunning)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        textfield.endEditing(true)
        
        return true
    }
    
}
