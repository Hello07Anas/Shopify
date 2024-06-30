//
//  productImgCellCollectionViewCell.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import UIKit
import SDWebImage

class productImgCellCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var zoomScrollView: UIScrollView!
    
    var isZoomEnabled = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isZoomEnabled {
            setupZoom()
        }
        
        self.isUserInteractionEnabled = true
        zoomScrollView.isUserInteractionEnabled = true
        productImg.isUserInteractionEnabled = true
    }
    
    
    
    func configure(with url: URL) {
        productImg.sd_setImage(with: url, completed: nil)
    }
    
    func setupZoom() {
        zoomScrollView.delegate = self
        zoomScrollView.minimumZoomScale = 1.0
        zoomScrollView.maximumZoomScale = 3.0
        zoomScrollView.zoomScale = 1.0

        zoomScrollView.isDirectionalLockEnabled = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        zoomScrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            guard let viewController = findViewController() as? ProductInfoVC else {
                return
            }

            if let indexPath = viewController.productImageCollectionView.indexPath(for: self) {
                guard let product = viewController.productInfoVM.getProduct() else { return }

                let imageURLs = product.images?.compactMap { URL(string: $0.src ?? "") } ?? []
                let selectedImageURL = imageURLs[indexPath.item]

                let imageZoomVC = ImageZoom(imageURLs: imageURLs, selectedImageURL: selectedImageURL)
                imageZoomVC.coordinator = viewController.coordinator

                viewController.navigationController?.pushViewController(imageZoomVC, animated: true)
            }
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    private func centerImage() {
        let imageViewSize = productImg.frame.size
        let scrollViewSize = zoomScrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        zoomScrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return productImg
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
