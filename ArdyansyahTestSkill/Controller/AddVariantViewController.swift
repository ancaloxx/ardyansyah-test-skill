//
//  AddVariantViewController.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 06/01/24.
//

import UIKit
import Kingfisher

protocol AddVariantControllerProtocol {
    func addVariant(variant: VariantsData)
}

class AddVariantViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var viewAddPhoto: UIView!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var buttonAddPhoto: UIButton!
    @IBOutlet weak var textfieldVariantName: UITextField!
    @IBOutlet weak var textfieldHarga: UITextField!
    @IBOutlet weak var textfieldStock: UITextField!
    @IBOutlet weak var buttonMin: UIButton!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var topInputView: NSLayoutConstraint!
    
    private let alertField = AlertField()
    
    var delegate: AddVariantControllerProtocol?
    var backTitleCurrent = ""
    var backTitleProduct = ""
    var stock = 0
    var imagePick = false
    var imageData = Data()
    var variant = VariantsData()
    var variantID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    private func initialSetup() {
        navigationBarSetup()
        keyboardSetup()
        viewAddPhotoSetup()
        
        textfieldVarientNameSetup()
        textfieldHargaSetup()
        textfieldStockSetup()
        
        buttonStockSetup()
        buttonAddSetup()
        
        dataSetup()
    }
    
    private func dataSetup() {
        if variant.name?.count != 0 && variant.name != nil {
            if backTitleProduct == "Create Product" || variantID == 0 {
                let imageStr = variant.image?.removeMimeType(imageStr: variant.image ?? "") ?? ""
                let imageStrData = Data(base64Encoded: imageStr) ?? Data()
                imageProduct.image = UIImage(data: imageStrData)
            } else {
                guard let url = URL(string: variant.image ?? "") else { return }
                imageProduct.kf.setImage(with: url)
            }
            imageProduct.contentMode = .scaleAspectFill
            
            textfieldVariantName.text = variant.name ?? ""
            textfieldHarga.text = "\(variant.price ?? 0)"
            textfieldStock.text = "\(variant.stock ?? 0)"
        }
    }
    
    private func navigationBarSetup() {
        let backImage = UIBarButtonItem(image: UIImage(named: "Component 14_1"), style: .plain, target: self, action: #selector(navigationBack))
        backImage.imageInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        
        let backTitle = UIBarButtonItem(title: backTitleCurrent, style: .plain, target: self, action: #selector(navigationBack))
        
        navigationItem.leftBarButtonItems = [backImage, backTitle]
    }
    
    @objc private func navigationBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func keyboardSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject> {
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyboardRect = frame?.cgRectValue
            if let keyHeight = keyboardRect?.height {
                self.topInputView.constant = -(keyHeight - 148.0)
            }
        }
    }
    
    @objc private func keyboardHide() {
        topInputView.constant = 16.0
    }
    
    private func viewAddPhotoSetup() {
        viewAddPhoto.viewShadow()
    }
    
    private func textfieldVarientNameSetup() {
        textfieldVariantName.placeholder = "variant product name"
        textfieldVariantName.textfieldBorder()
        
        textfieldVariantName.delegate = self
        textfieldVariantName.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    private func textfieldHargaSetup() {
        textfieldHarga.placeholder = "0"
        textfieldHarga.addTarget(self, action: #selector(changeText), for: .editingChanged)
        
        textfieldHarga.textfieldBorder()
        textfieldHarga.textfieldRp()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([spaceButton, doneButton], animated: false)
        
        textfieldHarga.inputAccessoryView = toolbar
    }
    
    @objc private func dismissKeyboard() {
        textfieldHarga.endEditing(true)
    }
    
    private func textfieldStockSetup() {
        textfieldStock.text = "\(stock)"
        textfieldStock.textfieldBorder()
        
        textfieldStock.isUserInteractionEnabled = false
        textfieldStock.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    
    @objc private func changeText() {
        alertField.removeFromSuperview()
    }
    
    private func buttonStockSetup() {
        buttonMin.buttonBorder(color: UIColor(named: "redColorCustom") ?? .systemGray4)
        buttonPlus.buttonBorder(color: UIColor(named: "greenColorCustom") ?? .systemGray4)
    }
    
    private func buttonAddSetup() {
        buttonAdd.layer.cornerRadius = 5.0
    }

    @IBAction func buttonAddPhotoAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewAddPhoto.transform = CGAffineTransformMakeScale(0.95, 0.95)
            self.viewAddPhoto.hideViewShadow()
        }, completion: { _ in
            self.viewAddPhoto.transform = CGAffineTransform.identity
            self.viewAddPhoto.viewShadow()
            
            let galleryPicker = UIImagePickerController()
            galleryPicker.delegate = self
            galleryPicker.sourceType = .savedPhotosAlbum
            galleryPicker.allowsEditing = false
            
            self.alertField.removeFromSuperview()
            
            self.present(galleryPicker, animated: true)
        })
    }
    
    @IBAction func buttonMinAction(_ sender: UIButton) {
        if stock != 0 {
            stock = stock - 1
        }
        
        textfieldStock.text = "\(stock)"
    }
    
    @IBAction func buttonPlusAction(_ sender: UIButton) {
        stock = stock + 1
        textfieldStock.text = "\(stock)"
    }
    
    @IBAction func buttonAddAction(_ sender: UIButton) {
        let imageBase64 = imagePick ? imageData.imageBase64URIOutputString : variant.image
        let name = textfieldVariantName.text ?? ""
        let harga = textfieldHarga.text ?? ""
        let hargaInt = Int(harga)
        let stock = textfieldStock.text ?? ""
        let stockInt = Int(stock)
        
        if imageBase64?.count != 0 && imageBase64 != nil {
            if !name.isEmpty {
                if !harga.isEmpty {
                    if stockInt != 0 {
                        var variant = VariantsData()
                        variant.name = name
                        variant.image = imageBase64
                        variant.price = hargaInt
                        variant.stock = stockInt
                        
                        self.delegate?.addVariant(variant: variant)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        showAlertField(result: "The stock field minimum 1")
                    }
                } else {
                    showAlertField(result: "The harga field required")
                }
            } else {
                showAlertField(result: "The name field required")
            }
        } else {
            showAlertField(result: "Please select image")
        }
    }
    
    private func showAlertField(result: String) {
        view.addSubview(alertField)
        
        alertField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertField.bottomAnchor.constraint(equalTo: buttonAdd.topAnchor, constant: -32.0),
            alertField.widthAnchor.constraint(equalToConstant: view.frame.width - 64.0),
            alertField.widthAnchor.constraint(equalToConstant: 100.0)
        ])
        
        alertField.layout(result: result)
    }
    
}

extension AddVariantViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageProduct.image = image
            self.imageProduct.contentMode = .scaleAspectFill
            self.imageData = imageProduct.image?.jpegData(compressionQuality: 0.1) ?? Data()
            
            let imageDataSize = Double(imageData.count) / 1024 / 1024
            
            self.imagePick = true
            self.dismiss(animated: true)
        }
    }
    
}

extension AddVariantViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        textfield.endEditing(true)
        return true
    }
    
}
