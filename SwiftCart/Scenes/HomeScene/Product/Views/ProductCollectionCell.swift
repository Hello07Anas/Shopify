//
//  ProductCollectionCell.swift
//  SwiftCart
//
//  Created by Elham on 10/06/2024.
//

import UIKit

class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.contentView.layer.cornerRadius = 30
        self.contentView.layer.borderWidth = 1.0
        let secColor = UIColor(.black)
        self.contentView.layer.borderColor = secColor.cgColor

    }

}
