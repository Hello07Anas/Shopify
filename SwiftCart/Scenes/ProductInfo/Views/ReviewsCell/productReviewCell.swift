//
//  productReviewCell.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import UIKit
import Cosmos

class productReviewCell: UICollectionViewCell {
    
    @IBOutlet weak var reviwerName: UILabel!
    @IBOutlet weak var reviewDescription: UITextView!
    @IBOutlet weak var cosmos: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }
    
    private func setupCellAppearance() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
        
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
    }
    
    func configure(with review: Review) {
        reviwerName.text = review.reviewerName
        reviewDescription.text = review.reviewDescription
        cosmos?.rating = review.reviewRating
        cosmos?.settings.updateOnTouch = false
    }
}
