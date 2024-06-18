//
//  ProductCartCell.swift
//  SwiftCart
//
//  Created by Israa on 16/06/2024.
//

import UIKit

class ProductCartCell: UITableViewCell {

    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productVariant: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
     var cellID: Int?
    private var quantity: Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCellAppearance() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
    
    @IBAction func minusBtn(_ sender: Any) {
    }
    @IBAction func plusBtn(_ sender: Any) {
    }
    
}

protocol ProductCartCellProtocol {
    func setCell(id: Int)
    func setProduct(_ product: LineItem)
    func setImage(with imageURLString: String?)
}

extension ProductCartCell : ProductCartCellProtocol {
    func setCell(id: Int) {
        cellID = id
    }
    
    func setProduct(_ product: LineItem) {
    
        productTitle.text = product.productTitle
        productPrice.text = "$\(product.productPrice)"
        productQuantity.text = "\(product.quantity)"
        if let sizeColor = product.sizeColor {
            productVariant.text = product.sizeColor
        } else {
            productVariant.isHidden = true
        }
    }
    
    func setImage(with imageURLString: String?) {
        guard let imageURLString = imageURLString, let imageUrl = URL(string: imageURLString) else {
            productImage.image = UIImage(named: "9")
            return
        }
        productImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "9"))
    }

    
    
}
