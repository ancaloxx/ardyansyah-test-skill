//
//  AddProductViewController.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 06/01/24.
//

import UIKit

class AddProductViewController: UIViewController {

    @IBOutlet weak var textfieldName: UITextField!
    @IBOutlet weak var textviewDescription: UITextView!
    @IBOutlet weak var listAddVariant: UITableView!
    @IBOutlet weak var buttonSave: UIButton!
    
    private let alertField = AlertField()
    private var indicatorRunning = IndicatorRunning()
    private var popUp = PopUp()
    private var backTitleCurrent = 0
    private var editCell = false
    
    var backTitleProduct = ""
    var productID = 0
    var product = Items()
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    private func initialSetup() {
        productDataSetup()
        textfieldNameSetup()
        
        listAddVariantSetup()
        buttonSaveSetup()
    }
    
    private func productDataSetup() {
        if !backTitleProduct.isEmpty {
            navigationBarSetup(title: backTitleProduct)
            
            textviewDescriptionSetup(title: backTitleProduct)
            textfieldName.text = product.title
            textviewDescription.text = product.description
            
            buttonSave.setTitle("Updata Product", for: .normal)
        } else {
            navigationBarSetup(title: "Create Product")
            textviewDescriptionSetup(title: "Create Product")
        }
    }
    
    private func navigationBarSetup(title: String) {
        let backImage = UIBarButtonItem(image: UIImage(named: "Component 14_1"), style: .plain, target: self, action: #selector(navigationBack))
        backImage.imageInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        let backTitle = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(navigationBack))
        
        if title != "Create Product" {
            let rightImage = UIBarButtonItem(image: UIImage(named: "Component 6_1"), style: .plain, target: self, action: #selector(barDeleteAction))
            navigationItem.rightBarButtonItem = rightImage
        }
        
        navigationItem.leftBarButtonItems = [backImage, backTitle]
    }
    
    @objc private func navigationBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func barDeleteAction() {
        showPopUp()
    }
    
    private func showPopUp() {
        popUp = PopUp(frame: view.frame)
        popUp.delegate = self
        
        popUp.labelInformation.text = "Are you sure to delete product \"\(backTitleProduct)\"?"
        view.addSubview(popUp)
    }
    
    private func textfieldNameSetup() {
        textfieldName.placeholder = "Product Name"
        textfieldName.textfieldBorder()
        
        textfieldName.delegate = self
        textfieldName.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    @objc private func changeText() {
        alertField.removeFromSuperview()
    }
    
    private func textviewDescriptionSetup(title: String) {
        if title == "Create Product" {
            textviewDescription.textviewPlaceholder()
        }
        
        textviewDescription.textviewBorder()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        textviewDescription.inputAccessoryView = toolbar
        textviewDescription.delegate = self
    }
    
    @objc private func dismissKeyboard() {
        textviewDescription.endEditing(true)
    }
    
    private func listAddVariantSetup() {
        let nibAddCell = UINib(nibName: "ListAddVariantCell", bundle: nil)
        listAddVariant.register(nibAddCell, forCellReuseIdentifier: "listAddVariant")
        
        let nibEditCell = UINib(nibName: "ListEditVariantCell", bundle: nil)
        listAddVariant.register(nibEditCell, forCellReuseIdentifier: "listEditVariant")
        listAddVariant.dataSource = self
        listAddVariant.showsVerticalScrollIndicator = false
    }
    
    private func buttonSaveSetup() {
        buttonSave.layer.cornerRadius = 5.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddVariantViewController {
            vc.delegate = self
            vc.backTitleCurrent = "Add Variant Product \(backTitleCurrent + 1)"
            vc.backTitleProduct = backTitleProduct
            
            if editCell {
                vc.variant = product.variants[backTitleCurrent]
                vc.variantID = product.variants[backTitleCurrent].id ?? 0
                vc.backTitleCurrent = "Edit Variant"
            }
        }
    }
    
    @IBAction func buttonSaveAction(_ sender: UIButton) {
        let name = textfieldName.text ?? ""
        let description = textviewDescription.text ?? ""
        
        if name.getNameProductValidation(nameProduct: name).isEmpty {
            if description.getDescriptionValidation(description: description).isEmpty && textviewDescription.textColor != .systemGray3 {
                if product.variants.count != 0 {
                    showIndicatorRunning()
                    product.title = name
                    product.description = description
                    
                    if sender.titleLabel?.text == "Save" {
                        APIManager.shareInstance.callingCreateProductAPI(key: key, product: product) { result in
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                let code = result["code"] as? String
                                let message = result["message"] as? String
                                
                                if code == "20000" {
                                    self.navigationController?.navigationBar.isHidden = false
                                    self.navigationController?.popViewController(animated: false)
                                    self.indicatorRunning.removeFromSuperview()
                                } else {
                                    self.navigationController?.navigationBar.isHidden = false
                                    self.indicatorRunning.removeFromSuperview()
                                    self.showAlertField(result: message ?? "")
                                }
                            }
                        }
                    } else {
                        APIManager.shareInstance.callingUpdateProduct(key: key, id: productID, product: product) { result in
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                let code = result["code"] as? String
                                let message = result["message"] as? String
                                
                                if code == "20000" {
                                    self.navigationController?.navigationBar.isHidden = false
                                    self.navigationController?.popViewController(animated: false)
                                    self.indicatorRunning.removeFromSuperview()
                                } else {
                                    self.navigationController?.navigationBar.isHidden = false
                                    self.indicatorRunning.removeFromSuperview()
                                    self.showAlertField(result: message ?? "")
                                }
                            }
                        }
                    }
                } else {
                    showAlertField(result: "Please add 1 variant product")
                }
            } else {
                showAlertField(result: "The description field required")
            }
        } else {
            showAlertField(result: "The name field required")
        }
    }
    
    private func showAlertField(result: String) {
        view.addSubview(alertField)
        
        alertField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertField.bottomAnchor.constraint(equalTo: buttonSave.topAnchor, constant: -32.0),
            alertField.widthAnchor.constraint(equalToConstant: view.frame.width - 64.0),
            alertField.widthAnchor.constraint(equalToConstant: 100.0)
        ])
        
        alertField.layout(result: result)
    }
    
    private func showIndicatorRunning() {
        navigationController?.navigationBar.isHidden = true
        
        indicatorRunning = IndicatorRunning(frame: view.frame)
        view.addSubview(indicatorRunning)
    }
}

extension AddProductViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray3 {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textviewPlaceholder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        alertField.removeFromSuperview()
    }
    
}

extension AddProductViewController: AddVariantControllerProtocol {
    
    func addVariant(variant: VariantsData) {
        if editCell {
            product.variants[backTitleCurrent] = variant
        } else {
            product.variants.append(variant)
        }
        
        listAddVariant.reloadData()
    }
    
}

extension AddProductViewController: PopUpProtocol {
    
    func buttonAction(action: Bool) {
        if action {
            APIManager.shareInstance.callingDeleteProduct(key: key, id: productID) { result in
                self.showIndicatorRunning()
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let code = result["code"] as? String
                    
                    if code == "20000" {
                        self.indicatorRunning.removeFromSuperview()
                        self.navigationController?.navigationBar.isHidden = false
                        self.navigationController?.popViewController(animated: false)
                    }
                }
            }
        } else {
            popUp.removeFromSuperview()
        }
    }
    
}

extension AddProductViewController: UITableViewDataSource, ListAddVariantCellProtocol, ListEditVariantCellProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if product.variants.count != 0 && indexPath.row < product.variants.count {
            let cell:ListEditVariantCell = tableView.dequeueReusableCell(withIdentifier: "listEditVariant", for: indexPath) as! ListEditVariantCell
            cell.delegate = self
            
            cell.selectionStyle = .none
            cell.variantDataSetup(variant: product.variants[indexPath.row], title: backTitleProduct)
            
            return cell
        } else {
            let cell:ListAddVariantCell = tableView.dequeueReusableCell(withIdentifier: "listAddVariant", for: indexPath) as! ListAddVariantCell
            cell.delegate = self
            
            cell.selectionStyle = .none
            cell.buttonAddVariant.tag = indexPath.row
            cell.buttonAddVariant.setTitle("Add Variant Product \(indexPath.row + 1)", for: .normal)
            
            return cell
        }
    }
    
    func clickAddVariantCell(index: Int) {
        alertField.removeFromSuperview()
        
        if index == product.variants.count {
            self.backTitleCurrent = index
            self.editCell = false
            self.performSegue(withIdentifier: "addvariantVC", sender: self)
        } else {
            showAlertField(result: "Variant \(product.variants.count + 1) is required")
        }
    }
    
    func clickEditVariantCell(index: Int) {
        self.editCell = true
        self.performSegue(withIdentifier: "addvariantVC", sender: self)
    }
    
}

extension AddProductViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        textfield.endEditing(true)
        return true
    }
    
}
