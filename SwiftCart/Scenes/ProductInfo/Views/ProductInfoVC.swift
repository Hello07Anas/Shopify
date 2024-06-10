//
//  ProductInfoVC.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import UIKit
import Cosmos

class ProductInfoVC: UIViewController{
    
    weak var coordinator: AppCoordinator?
    
    var productInfoVM: ProductInfoVM!
    
    @IBOutlet weak var productImageCollectionView: UICollectionView!
    @IBOutlet weak var productReviesCollectionView: UICollectionView!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel! // e.g "820.25 EGP"
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProductImageCollectionView()
        setupProductReviesCollectionView()
        
        setDataOfProduct()
    }

    @IBAction func addToFavBtn(_ sender: Any) {
        // TOOD: Add to FAV
    }
    

    @IBAction func addToCartBtn(_ sender: Any) {
        // TOOD: Add to Cart
    }
    
    // helper Methods
    
    func setupProductImageCollectionView() {
        productImageCollectionView.dataSource = self
        productImageCollectionView.delegate = self

        let productImageNib = UINib(nibName: "productImgCellCollectionViewCell", bundle: nil)
        productImageCollectionView.register(productImageNib, forCellWithReuseIdentifier: "productImgCellCollectionViewCell")
        
        if let layout = productImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: productImageCollectionView.frame.width, height: productImageCollectionView.frame.height)
            layout.minimumLineSpacing = 8
            layout.minimumInteritemSpacing = 8
            layout.scrollDirection = .horizontal
        }
    }
    
    func setupProductReviesCollectionView() {
        productReviesCollectionView.dataSource = self
        productReviesCollectionView.delegate = self

        let productReviewNib = UINib(nibName: "productReviewCell", bundle: nil)
        productReviesCollectionView.register(productReviewNib, forCellWithReuseIdentifier: "productReviewCell")

        if let reviewLayout = productReviesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            reviewLayout.itemSize = CGSize(width: productReviesCollectionView.frame.width - 48, height: 85)
            reviewLayout.minimumLineSpacing = 8
            reviewLayout.minimumInteritemSpacing = 0
            reviewLayout.scrollDirection = .horizontal
        }
        
        pageControl.numberOfPages = 10
        pageControl.currentPage = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == productImageCollectionView {
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = Int(pageIndex)
        }
    }
    
    func setDataOfProduct() {
        if let product = productInfoVM.getProduct() as? SwiftCart.Product {
            productName.text = product.title
            productPrice.text = "\(product.variants.first?.price ?? "0.00") EGP"
            productDescription.text = product.bodyHTML

            pageControl.numberOfPages = product.images.count
        }
        
        productImageCollectionView.reloadData()
    }
    
    

}

// MARK: Extension

extension ProductInfoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productImageCollectionView {
            return (productInfoVM.getProduct() as? SwiftCart.Product)?.images.count ?? 0
        } else if collectionView == productReviesCollectionView {
            return 25
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == productImageCollectionView {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImgCellCollectionViewCell", for: indexPath) as! productImgCellCollectionViewCell
//            return cell
        if collectionView == productImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImgCellCollectionViewCell", for: indexPath) as! productImgCellCollectionViewCell
            
            if let product = productInfoVM.getProduct() as? SwiftCart.Product {
                let imageURLString = product.images[indexPath.item].src
                if let url = URL(string: imageURLString) {
                    cell.configure(with: url)
                }
            }
            return cell
        } else if collectionView == productReviesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productReviewCell", for: indexPath) as! productReviewCell

            var review: Review

            if indexPath.item < 4 {
                review = dummyReviews[indexPath.item]
            } else {
                let randomIndex = Int.random(in: 0..<dummyReviews.count)
                review = dummyReviews[randomIndex]
            }

            cell.configure(with: review)

            return cell
        }
        return UICollectionViewCell()
    }
}


/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/

