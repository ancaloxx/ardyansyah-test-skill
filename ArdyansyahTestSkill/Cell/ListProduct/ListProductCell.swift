//
//  ListProductCell.swift
//  ArdyansyahTestSkill
//
//  Created by anca dev on 08/01/24.
//

import UIKit
import Kingfisher

protocol ListProductCellProtocol {
    func clickProductCell(index: Int)
}

class ListProductCell: UICollectionViewCell {

    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelTotalVariant: UILabel!
    @IBOutlet weak var labelTotalStock: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var buttonProduct: UIButton!
    
    var delegate: ListProductCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func productDataSetup(item: Items) {
        guard let url = URL(string: item.image ?? "") else { return }
        imageProduct.kf.setImage(with: url)
        
        let imageData = imageProduct.image?.jpegData(compressionQuality: 1.0)
        print(imageData)
        
        labelName.text = item.title
        labelTotalVariant.text = "Total Variant: \(item.total_variant ?? 0)"
        labelTotalStock.text = "Total Variant: \(item.total_stok ?? 0)"
        labelPrice.text = item.price?.idrCurrency(price: item.price ?? 0)
    }

    @IBAction func buttonProductAction(_ sender: UIButton) {
        delegate?.clickProductCell(index: sender.tag)
    }
    
}
