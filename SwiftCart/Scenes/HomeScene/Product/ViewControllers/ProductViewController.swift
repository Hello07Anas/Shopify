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
        setUpPriceFilter()
        if let brandID = brandID {
            viewModel.getCategoryProducts(categoryId: brandID)
        }
        fetchFavoriteItems()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchFavoriteItems()
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
            viewModel.getCategoryProducts(categoryId: brandID ?? 0)
            viewModel.isFiltering = false
        case 1:
            self.viewModel.filterProductsArray(productType: "SHOES")
        case 2:
            self.viewModel.filterProductsArray(productType: "ACCESSORIES")
        case 3:
            self.viewModel.filterProductsArray(productType: "T-SHIRTS")
        default:
            viewModel.getCategoryProducts(categoryId: brandID ?? 0)
        }
    }
    
    
    func setUpPriceFilter() {
        sliderPrice.rx.value
            .distinctUntilChanged()
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                DispatchQueue.global().async {
                    self.viewModel.filterProducts(price: value)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupBindings() {
        viewModel.categoriesObservable?
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] products in
                self?.products = products
                self?.updateSliderRange()
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func updateSliderRange() {
        let prices = products.compactMap { Float($0.variants[0].price) }
        if let minPrice = prices.min(), let maxPrice = prices.max() {
            sliderPrice.minimumValue = minPrice - 30
            sliderPrice.maximumValue = maxPrice + 30
            sliderPrice.value = maxPrice
        }
    }

    
    @IBAction func backTToHome(_ sender: Any) {
        coordinator?.finish()
    }
  
    
    @IBAction func favBtn(_ sender: Any) {
        coordinator?.goToFav()
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
        cell.price.text = product.variants[0].price.formatAsCurrency()
           
           cell.isCellNowHome = true
           cell.indexPath = indexPath
           cell.delegate = self
           cell.isFavorited = favoriteProductIDs.contains(product.id)
           cell.setButtonImage(isFavorited: cell.isFavorited)
           
           return cell
       }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let selectedProduct = viewModel.getProducts()[indexPath.row]
//        let isFavorited = favoriteProductIDs.contains(selectedProduct.id)
//
//        coordinator?.goToProductInfo(productId: selectedProduct.id, isFav: isFavorited) //TODO: change flase to be dynamic
//        //print("Item Selected")
//    }
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize / 2, height: ( collectionViewSize / 2))
    }
    
    func createProductsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)
        
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [item])
        
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [horizontalGroup])
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 2, trailing: 4)
        section.interGroupSpacing = 10
        
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.createProductsSectionLayout()
           
            default:
                return nil
            }
        }
        collectionView.collectionViewLayout = layout
    }
}





extension ProductViewController: ProductCollectionCellDelegate {
    func saveToFavorite(for cell: ProductCollectionCell, completion: @escaping () -> Void) {
            guard let indexPath = cell.indexPath else {
                print("No index path found for cell")
                completion()
                return
            }
            
            let product = products[indexPath.item]
            let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
            
            favCRUD.saveItem(favId: favId!, itemId: product.id, itemImg: product.image.src, itemName: product.title, itemPrice: Double(product.variants[0].price) ?? 70.0) { success in
                if success {
                    DispatchQueue.main.async {
                        self.favoriteProductIDs.insert(product.id)
                        completion()
                    }
                } else {
                    // Handle save failure if needed
                    print("Failed to save item to favorites")
                    completion()
                }
            }
        }
        
        func deleteFavoriteTapped(for cell: ProductCollectionCell, completion: @escaping () -> Void) {
            guard let indexPath = cell.indexPath else {
                print("No index path found for cell")
                completion()
                return
            }
            
            let product = products[indexPath.item]
            let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
            
            favCRUD.deleteItem(favId: favId!, itemId: product.id) { success in
                if success {
                    DispatchQueue.main.async {
                        self.favoriteProductIDs.remove(product.id)
                        completion()
                    }
                } else {
                    // Handle delete failure if needed
                    print("Failed to delete item from favorites")
                    completion()
                }
            }
        }
    
    
    func goToDetails(item cell: ProductCollectionCell){
        let selectedProduct = viewModel.getProducts()[cell.indexPath?.row ?? 0]
        let isFavorited = favoriteProductIDs.contains(selectedProduct.id)

        coordinator?.goToProductInfo(productId: selectedProduct.id, isFav: isFavorited)
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
