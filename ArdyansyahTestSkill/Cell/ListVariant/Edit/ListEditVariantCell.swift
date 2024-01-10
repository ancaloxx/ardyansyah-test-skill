//
//  ListVariantCell.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 08/01/24.
//

import UIKit
import Kingfisher

protocol ListEditVariantCellProtocol {
    func clickEditVariantCell(index: Int)
}

class ListEditVariantCell: UITableViewCell {

    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelStock: UILabel!
    
    var delegate: ListEditVariantCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    private func initialSetup() {
        viewCellSetup()
    }
    
    private func viewCellSetup() {
        viewCell.viewBorder()
    }
    
    func variantDataSetup(variant: VariantsData, title: String) {
        if title.isEmpty {
            let imageStr = variant.image?.removeMimeType(imageStr: variant.image ?? "") ?? ""
            let imageStrData = Data(base64Encoded: imageStr) ?? Data()
            imageProduct.image = UIImage(data: imageStrData)
        } else {
            guard let url = URL(string: variant.image ?? "") else { return }
            imageProduct.kf.setImage(with: url)
        }
        
        labelName.text = variant.name ?? ""
        labelPrice.text = variant.price?.idrCurrency(price: variant.price ?? 0)
        labelStock.text = "\(variant.stock ?? 0) pcs"
    }
    
    @IBAction func buttonEditVariantAction(_ sender: UIButton) {
        delegate?.clickEditVariantCell(index: sender.tag)
    }
}
