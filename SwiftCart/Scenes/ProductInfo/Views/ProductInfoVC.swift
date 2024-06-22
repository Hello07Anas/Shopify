//
//  ProductInfoVC.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import UIKit
import Cosmos
import RxSwift

class ProductInfoVC: UIViewController{
    
    weak var coordinator: AppCoordinator?
    var productInfoVM: ProductInfoVM!
    private let disposeBag = DisposeBag()
    let favCRUD = FavCRUD()
    var id: Int = 0
    let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")

    @IBOutlet weak var productImageCollectionView: UICollectionView!
    @IBOutlet weak var productReviesCollectionView: UICollectionView!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel! // e.g "820.25 EGP"
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cosmos: CosmosView!
    @IBOutlet weak var addToFavBtn: UIButton!
    
    var isFavorited = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProductImageCollectionView()
        setupProductReviesCollectionView()
        
        productInfoVM.productObservable
            .subscribe(onNext: { [weak self] product in
                self?.updateProductDetails(product)
            })
            .disposed(by: disposeBag)
        
        productInfoVM.fetchProduct(with: id)
        
        cosmos.rating = getRandomRating()
        setButtonImage(isFavorited: isFavorited)
    }

    @IBAction func addToFavBtn(_ sender: Any) {
        guard let product = productInfoVM.getProduct() else { return }
        let itemId = product.id

        isFavorited.toggle()
//        setButtonImage(isFavorited: isFavorited)
        
        if isFavorited {
            let itemImg = product.images?.first?.src ?? ""
            let itemName = product.title
            let itemPrice = Double(product.variants?.first?.price ?? "0.0") ?? 0.0
            
            favCRUD.saveItem(favId: favId!, itemId: itemId!, itemImg: itemImg, itemName: itemName!, itemPrice: itemPrice)
//            print("favId when save is =========================== \(favId!)")
//            print("itemId when save is =========================== \(itemId!)")
            setButtonImage(isFavorited: true)
        } else {
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in

                self.favCRUD.deleteItem(favId: self.favId!, itemId: itemId!)
                
//                print("favId when delete is =========================== \(self.favId!)")
//                print("itemId when delete is =========================== \(itemId!)")
                
                self.setButtonImage(isFavorited: false) // Example UI update
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            Utils.showAlert(title: "Confirm Deletion", message: "Are you sure you want to remove this item from favorites?", preferredStyle: .alert, from: self, actions: [deleteAction, cancelAction])
        }
    }

    @IBAction func addToCartBtn(_ sender: Any) {
        // TOOD: Add to Cart
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        coordinator?.finish()
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

    func updateProductDetails(_ product: ShopifyProduct) {
        //print("Updating UI with product details:", product)
        productName.text = product.title
        productPrice.text = "\(product.variants?.first?.price ?? "90.00")".formatAsCurrency()
        productDescription.text = product.body_html
        pageControl.numberOfPages = product.images?.count ?? 0

        productImageCollectionView.reloadData()
    }


    func getRandomRating() -> Double {
        let randomRating = Double.random(in: 3.0...5.0)
        return (randomRating * 10).rounded() / 10.0
    }

    func setButtonImage(isFavorited: Bool) {
        let imageName = isFavorited ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        addToFavBtn.setImage(image, for: .normal)
    }

}

// MARK: Extension

extension ProductInfoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productImageCollectionView {
            return productInfoVM.getProduct()?.images?.count ?? 0
        } else if collectionView == productReviesCollectionView {
            return 25
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productImageCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImgCellCollectionViewCell", for: indexPath) as! productImgCellCollectionViewCell
            
            if let product = productInfoVM.getProduct() {
                let imageURLString = product.images?[indexPath.item].src
                if let url = URL(string: imageURLString!) {
                    cell.configure(with: url)
                }
            }
            
            return cell
        } else if collectionView == productReviesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productReviewCell", for: indexPath) as! productReviewCell
            
            let randomIndex = Int.random(in: 0..<dummyReviews.count)
            let review = dummyReviews[randomIndex]
            
            let randomReviewerName = reviewers.randomElement() ?? "Anas"
            let randomReview = Review(reviewerName: randomReviewerName, reviewDescription: review.reviewDescription, reviewRating: review.reviewRating)
            
            cell.configure(with: randomReview)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = productInfoVM.getProduct() else { return }
        
        let imageURLs = product.images?.compactMap { URL(string: $0.src ?? "") } ?? []
        let selectedImageURL = imageURLs[indexPath.item]
        
        coordinator?.goToImageZoom(imageURLs: imageURLs, selectedImageURL: selectedImageURL)
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

