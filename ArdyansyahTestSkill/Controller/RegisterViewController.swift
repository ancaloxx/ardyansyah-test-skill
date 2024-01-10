//
//  RegisterViewController.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 05/01/24.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldPasswordConfirm: UITextField!
    @IBOutlet weak var buttonRegister: UIButton!
    
    private let alertField = AlertField()
    private var indicatorRunning = IndicatorRunning()
    private var key = ""
    
    var onClick1 = false
    var onClick2 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    private func initialSetup() {
        navigationBarSetup()
        textfieldNameSetup()
        textfieldEmailSetup()
        
        textfieldPasswordSetup()
        textfieldPasswordConfirmSetup()
        buttonRegisterSetup()
    }
    
    private func navigationBarSetup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Component 14_1"), style: .plain, target: self, action: #selector(navigationBack))
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc private func navigationBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func textfieldNameSetup() {
        textfieldName.textfieldBorder()
        textfieldName.placeholder = "john doe"
        
        textfieldName.delegate = self
        textfieldName.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    private func textfieldEmailSetup() {
        textfieldEmail.textfieldBorder()
        textfieldEmail.placeholder = "johndoe@sample.com"
        
        textfieldEmail.delegate = self
        textfieldEmail.keyboardType = .emailAddress
        textfieldEmail.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    private func textfieldPasswordSetup() {
        textfieldPassword.textfieldBorder()
        textfieldPassword.textfieldImage(onClick: onClick1).addTarget(self, action: #selector(onClickEyes1), for: .touchUpInside)
        
        textfieldPassword.delegate = self
        textfieldPassword.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    @objc private func onClickEyes1() {
        onClick1 = !onClick1
        textfieldPassword.textfieldImage(onClick: onClick1).addTarget(self, action: #selector(onClickEyes1), for: .touchUpInside)
    }
    
    private func textfieldPasswordConfirmSetup() {
        textfieldPasswordConfirm.textfieldBorder()
        textfieldPasswordConfirm.textfieldImage(onClick: onClick2).addTarget(self, action: #selector(onClickEyes2), for: .touchUpInside)
        
        textfieldPasswordConfirm.delegate = self
        textfieldPasswordConfirm.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    @objc private func onClickEyes2() {
        onClick2 = !onClick2
        textfieldPasswordConfirm.textfieldImage(onClick: onClick2).addTarget(self, action: #selector(onClickEyes2), for: .touchUpInside)
    }
    
    @objc private func changeText() {
        alertField.removeFromSuperview()
    }
    
    private func buttonRegisterSetup() {
        buttonRegister.layer.cornerRadius = buttonRegister.frame.height / 2.0
    }

    @IBAction func buttonRegisterAction(_ sender: UIButton) {
        let name = textfieldName.text ?? ""
        let email = textfieldEmail.text ?? ""
        let password = textfieldPassword.text ?? ""
        let passwordConfirm = textfieldPasswordConfirm.text ?? ""
        let register = Register(name: name, email: email, password: password)
        
        if !name.isEmpty {
            if email.getEmailValidation(email: email).isEmpty {
                if password.getPasswordValidation(password: password).isEmpty {
                    if passwordConfirm == password {
                        showIndicatorRunning()
                        
                        APIManager.shareInstance.callingRegisterAPI(register: register) { result in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                let code = result["code"] as? String ?? ""
                                let message = result["message"] as? String ?? ""
                                
                                if code == "20000" {
                                    self.performSegue(withIdentifier: "listproductVC", sender: self)
                                    
                                    let login = Login(
                                        email: email,
                                        password: password
                                    )
                                    APIManager.shareInstance.callingLoginAPI(login: login) { result in
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
                                } else {
                                    self.navigationController?.navigationBar.isHidden = false
                                    
                                    self.indicatorRunning.removeFromSuperview()
                                    self.showAlertField(result: message)
                                }
                            }
                        }
                    } else {
                        if passwordConfirm.isEmpty {
                            showAlertField(result: "The password confirm field required")
                        } else {
                            showAlertField(result: "The password not same")
                        }
                    }
                } else {
                    let errorStr = password.getPasswordValidation(password: password).joined(separator: ", ")
                    showAlertField(result: errorStr)
                }
            } else {
                showAlertField(result: email.getEmailValidation(email: email))
            }
        } else {
            showAlertField(result: "The name field is required.")
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
            alertField.bottomAnchor.constraint(equalTo: buttonRegister.topAnchor, constant: -32.0),
            alertField.widthAnchor.constraint(equalToConstant: view.frame.width - 64.0),
            alertField.heightAnchor.constraint(equalToConstant: 100.0),
        ])
        
        self.alertField.layout(result: result)
    }
    
    private func showIndicatorRunning() {
        navigationController?.navigationBar.isHidden = true
        
        indicatorRunning = IndicatorRunning(frame: view.frame)
        view.addSubview(indicatorRunning)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        textfield.endEditing(true)
        return true
    }
    
}
