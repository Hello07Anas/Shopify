//
//  ProductViewController.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//

import UIKit
import RxSwift

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var sliderPrice: UISlider!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var subCategoriesView: UISegmentedControl!
    
    @IBOutlet weak var topconstrensinCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var isFilterHidden = true
    let favCRUD = FavCRUD()

    weak var coordinator: AppCoordinator?
    private let disposeBag = DisposeBag()
    private var products: [Product] = []
    private var favoriteProductIDs: Set<Int> = [] // TODO: s
    var brandID: Int?
    var viewModel = CategoryViewModel(network: NetworkManager.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderPrice.isHidden = isFilterHidden
        subCategoriesView.isHidden = isFilterHidden
        topconstrensinCollectionView.constant = 8
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: "ProductCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        setupBindings()
        if let brandID = brandID {
            viewModel.getCategoryProducts(categoryId: brandID)
        }
        fetchFavoriteItems()
        setupSearchBar()
    }
    
    private func fetchFavoriteItems() {
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0") ?? 0
        favCRUD.readItems(favId: favId) { [weak self] lineItems in
            DispatchQueue.main.async {
                self?.favoriteProductIDs = Set(lineItems.compactMap { $0.id })
                self?.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func filter(_ sender: Any) {
        isFilterHidden = !isFilterHidden
        UIView.animate(withDuration: 0.5) {
            self.subCategoriesView.isHidden = self.isFilterHidden
            self.sliderPrice.isHidden = self.isFilterHidden
            self.topconstrensinCollectionView.constant = self.isFilterHidden ? 8 : (self.subCategoriesView.frame.height + self.sliderPrice.frame.height + 16)
            self.view.layoutIfNeeded()
        }
        
    }
    @IBAction func SubCategoriesBtn(_ sender: Any) {
        switch subCategoriesView.selectedSegmentIndex {
        case 0:
            self.viewModel.filterProductsArray(productType: "T-SHIRTS")
        case 1:
            self.viewModel.filterProductsArray(productType: "SHOES")
        case 2:
            self.viewModel.filterProductsArray(productType: "ACCESSORIES")
        default:
            self.viewModel.filterProductsArray(productType: "T-SHIRTS")
        }
    }
    
    func setupBindings() {
        viewModel.categoriesObservable?
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] products in
                self?.products = products
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func backTToHome(_ sender: Any) {
        coordinator?.finish()
    }
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionCell
        let product = products[indexPath.item]
        if let imageUrl = URL(string: product.image.src) {
            cell.img.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "9"))
        }
        cell.ProductName.text = product.title
        cell.price.text = product.variants[0].price
        
        cell.isCellNowHome = true
        cell.indexPath = indexPath
        cell.delegate = self
        cell.isFavorited = favoriteProductIDs.contains(product.id)
        cell.setButtonImage(isFavorited: cell.isFavorited)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedProduct = viewModel.getProducts()[indexPath.row]
        let isFavorited = favoriteProductIDs.contains(selectedProduct.id)

        coordinator?.goToProductInfo(productId: selectedProduct.id, isFav: isFavorited) //TODO: change flase to be dynamic
        //print("Item Selected")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: ( collectionViewSize / 2))
    }
}

extension ProductViewController: ProductCollectionCellDelegate {
    func saveToFavorite(foe cell: ProductCollectionCell) {
        guard let indexPath = cell.indexPath else {
            print("No index path found for cell")
            return
        }
        
        let product = products[indexPath.item]
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        favCRUD.saveItem(favId: favId!, itemId: product.id, itemImg: product.image.src, itemName: product.title, itemPrice: Double(product.variants[0].price) ?? 70.0)
    }
    
    
    func deleteFavoriteTapped(for cell: ProductCollectionCell) {
        guard let indexPath = cell.indexPath else {
            print("No index path found for cell")
            return
        }
        
        let product = products[indexPath.item]
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        favCRUD.deleteItem(favId: favId!, itemId: product.id)
    }
}

extension ProductViewController: UISearchBarDelegate {
    
    func setupSearchBar() {
        searchBar.delegate = self
        bindSearchBar()
    }
    
    private func bindSearchBar() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.searchProducts(query: query)
            })
            .disposed(by: disposeBag)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchProducts(query: searchText)
    }
}
