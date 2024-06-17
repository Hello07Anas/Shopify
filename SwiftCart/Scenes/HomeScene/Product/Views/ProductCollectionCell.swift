//
//  ProductCollectionCell.swift
//  SwiftCart
//
//  Created by Elham on 10/06/2024.
//

import UIKit

protocol ProductCollectionCellDelegate: AnyObject {
    func deleteFavoriteTapped(for cell: ProductCollectionCell)
}

class ProductCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var addFavBtnOL: UIButton!
    
    var isFavorited = false
    var isCellNowFav = false
    weak var delegate: ProductCollectionCellDelegate?
    var indexPath: IndexPath?
    var coordinator: AppCoordinator?
    
    
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

    func configure(with product: ProductDumy, isFavorited: Bool) {
        ProductName.text = product.name
        price.text = product.price
        
        if let url = URL(string: product.imageName) {
            img.load(url: url)
        } else {
            img.image = UIImage(named: product.imageName)
        }
        
        setButtonImage(isFavorited: isFavorited)
    }
    
    @IBAction func addToCartBtn(_ sender: Any) { // TODO: change this btn name to goToDetails
        //coordinator?.goToProductInfo(productId: product.id)
    }
    
    @IBAction func addToFavBtn(_ sender: Any) {
        if isCellNowFav {
            deleteItemFromFavScreen()
        } else {
            if isFavorited {
                let yes = UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    self.isFavorited = false
                    self.setButtonImage(isFavorited: false)
                    //self.delegate?.deleteFavoriteTapped(for: self) // TODO: handel it using delegate
                })
                let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
                
                if let viewController = self.contentView.parentViewController {
                    Utils.showAlert(title: "Already Favorited", message: "\(self.ProductName.text!) is already in your favorites. Do you want to remove it?", preferredStyle: .alert, from: viewController, actions: [yes, no])
                }
            } else {
                isFavorited.toggle()
                setButtonImage(isFavorited: isFavorited)
            }
        }
    }
    
    func deleteItemFromFavScreen() {
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.delegate?.deleteFavoriteTapped(for: self)
        })
        let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        if let viewController = self.contentView.parentViewController {
            Utils.showAlert(title: "Confirmation", message: "Are you sure you want to remove \(self.ProductName.text!) from your favorites? This action cannot be undone.", preferredStyle: .alert, from: viewController, actions: [yes, no])
        }
    }
    
    func setButtonImage(isFavorited: Bool) {
        // TODO: Bougs here >><< when scroll the fill reused again
        let imageName = isFavorited ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        addFavBtnOL.setImage(image, for: .normal)
    }
    
    func setBtnImg() {
        if isCellNowFav {
            let image = UIImage(systemName: "trash")
            addFavBtnOL.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "heart")
            addFavBtnOL.setImage(image, for: .normal)
        }
    }
}

extension UIView { // helps with alert i present
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

/*
 if isCellNowFav {
 // here logic of Anas // TODO: Remove From Fav logic
} else {
 // here logic of elham // TODO: Add to Fav logic
 isFavorited.toggle()
 setButtonImage(isFavorited: isFavorited)
}
 */
