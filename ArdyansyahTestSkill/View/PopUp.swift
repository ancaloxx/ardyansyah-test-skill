//
//  PopUp.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 09/01/24.
//

import UIKit

protocol PopUpProtocol {
    func buttonAction(action: Bool)
}

class PopUp: UIView {

    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var labelInformation: UILabel!
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var buttonYes: UIButton!
    
    var delegate: PopUpProtocol?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        initialSetup()
    }
    
    private func setupXib(frame: CGRect) {
        let view = loadXib()
        view.frame = frame
        
        addSubview(view)
    }
    
    private func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PopUp", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView()
        }
        
        return view
    }
    
    private func initialSetup() {
        viewPopUpSetup()
        buttonNoSetup()
        buttonYesSetup()
    }
    
    private func viewPopUpSetup() {
        viewPopUp.layer.cornerRadius = 10.0
    }
    
    private func buttonNoSetup() {
        buttonNo.buttonBorder(color: UIColor(named: "redColorCustom") ?? .systemGray4)
    }
    
    private func buttonYesSetup() {
        buttonYes.layer.cornerRadius = 5.0
    }

    @IBAction func buttonNoAction(_ sender: UIButton) {
        let delete = sender.titleLabel?.text == "YES" ? true : false
        delegate?.buttonAction(action: delete)
    }
    
    @IBAction func buttonYesAction(_ sender: UIButton) {
        let delete = sender.titleLabel?.text == "YES" ? true : false
        delegate?.buttonAction(action: delete)
    }
    
}
