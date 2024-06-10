//
//  productImgCellCollectionViewCell.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import UIKit
import SDWebImage

class productImgCellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with url: URL) {
        productImg.sd_setImage(with: url, completed: nil)
    }
}
