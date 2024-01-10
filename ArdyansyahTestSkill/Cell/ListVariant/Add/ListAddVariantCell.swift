//
//  ListVariantCell.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 08/01/24.
//

import UIKit

protocol ListAddVariantCellProtocol {
    func clickAddVariantCell(index: Int)
}

class ListAddVariantCell: UITableViewCell {

    @IBOutlet weak var buttonAddVariant: UIButton!
    
    var delegate: ListAddVariantCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        buttonAddVariantSetup()
    }
    
    private func buttonAddVariantSetup() {
        buttonAddVariant.buttonBorder(color: UIColor(named: "blueColorCustom") ?? .systemGray4)
    }
    
    @IBAction func buttonAddVariantAction(_ sender: UIButton) {
        delegate?.clickAddVariantCell(index: sender.tag)
    }
    
}
