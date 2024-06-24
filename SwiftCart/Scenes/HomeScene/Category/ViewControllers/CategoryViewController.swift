//
//  CategoryViewController.swift
//  SwiftCart
//
//  Created by Elham on 03/06/2024.
//

import UIKit
import RxSwift

class CategoryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var InternetConnectionView: UIView!
    var isInternetConnection:Bool?
    var testViewModel = OrderViewModel()
    
    @IBOutlet weak var categoriesSegmented: UISegmentedControl!
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
    
    var viewModel = CategoryViewModel(network: NetworkManager.shared)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isInternetConnection = Utils.isNetworkReachableTest()
        print(isInternetConnection ?? false)
        if isInternetConnection == true {
            InternetConnectionView.isHidden = true
            viewModel.getAllProducts()
            fetchFavoriteItems()
        }else {
            InternetConnectionView.isHidden = false

        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("viewDidLoad ======================= CategoryViewController")
        
         setupCollectionViewLayout()
        subCategoriesView.isHidden = isFilterHidden
        topconstrensinCollectionView.constant = 8
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "ProductCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ProductCell")
        
        testViewModel.bindOrder = {
            self.coordinator?.finish()
        }
        
        setupBindings()
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
    
    @IBAction func tryAgain(_ sender: Any) {
        isInternetConnection = Utils.isNetworkReachableTest()
        if isInternetConnection == true {
            InternetConnectionView.isHidden = true
            viewModel.getAllProducts()
            fetchFavoriteItems()
        }else {
            InternetConnectionView.isHidden = false

        }    }
    @IBAction func filter(_ sender: Any) {
        let address = Address(
            id: nil,
            customerID: nil,
            firstName: "John",
            lastName: "Doe",
            address1: "123 Main St",
            city: "Cairo",
            country: "EG",
            phone: "011123456789",
            isDefault: true
        )
        
        let billingAddress = Address(
            id: nil,
            customerID: nil,
            firstName: "John",
            lastName: "Doe",
            address1: "123 Main St",
            city: "Cairo",
            country: "EG",
            phone: "011123456789",
            isDefault: true
        )
        
        let testOrder = Order(
            id: 1073460025,
            orderNumber: "#122",
            productNumber: 2,
            address: address,
            // phone: "011123456789",
            date: "2024-05-14T21:19:37-04:00",
            currency: .eur,
            email: UserDefaults.standard.string(forKey: "userEmail") ?? "",
            totalPrice: "238.47",
            items: [
                ItemProductOrder(id: 1071823276, image: "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402", price: "80", quantity: 3, title: "Big Brown Bear Boots"),
                ItemProductOrder(id: 1081823276, image: "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402", price: "50", quantity: 1, title: " Brown Bear Boots")
            ],
            userID: Int(K.Shopify.userID),
            billingAddress: billingAddress,
            customer: UserDefaultsHelper.shared.printUserDefaults()
        )
        
        testViewModel.addNewOrder(newOrder: testOrder)
        
        
        isFilterHidden = !isFilterHidden
        UIView.animate(withDuration: 0.5) {
            self.subCategoriesView.isHidden = self.isFilterHidden
            
            self.topconstrensinCollectionView.constant = self.isFilterHidden ? 8 : (self.subCategoriesView.frame.height + 16)
            self.view.layoutIfNeeded()
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
    
   
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        viewModel.clearFilter()  // Clear any previous filters
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.getAllProducts()
        case 1:
            viewModel.getCategoryProducts(categoryId: K.CategoryID.MEN)
        case 2:
            viewModel.getCategoryProducts(categoryId: K.CategoryID.WOMEN)
        case 3:
            viewModel.getCategoryProducts(categoryId: K.CategoryID.SALE)
        case 4:
            viewModel.getCategoryProducts(categoryId: K.CategoryID.KID)
        default:
            viewModel.getAllProducts()
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
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getProductsCount()
    }
    
    @IBAction func goToFav(_ sender: Any) {
        coordinator?.goToFav()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionCell
        
        let product = viewModel.getProducts()[indexPath.item]
        if let imageUrl = URL(string: viewModel.getProducts()[indexPath.row].image?.src ?? "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402") {
            cell.img.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "9"))
        }
        cell.ProductName.text = product.title
        cell.price.text = product.variants?[0]?.price?.formatAsCurrency()
        cell.isCellNowCategorie = true
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.isFavorited = favoriteProductIDs.contains(product.id ?? 0)
        cell.setButtonImage(isFavorited: cell.isFavorited)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let spacing: CGFloat = 10
            let sectionInsets: CGFloat = 24
            let totalSpacing = spacing + sectionInsets * 2
            let width = (collectionView.frame.width - totalSpacing) / 2
            return CGSize(width: width, height: 150)
        }
    
    func createProductsSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing:10)
        
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [item])
        
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalWidth(0.5))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [horizontalGroup])
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 2, trailing: 4)
        section.interGroupSpacing = 10
        
    
        
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

//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return 10
//        }
//
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 10
//        }
}

extension CategoryViewController: ProductCollectionCellDelegate {
    func saveToFavorite(for cell: ProductCollectionCell, completion: @escaping() -> Void) {
        guard let indexPath = cell.indexPath else {
            print("No index path found for cell")
            completion()
            return
        }
        let product = products[indexPath.item]
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        favCRUD.saveItem(favId: favId!, itemId: product.id, itemImg: product.image.src, itemName: product.title, itemPrice: Double(product.variants[0].price) ?? 70.0) { success in
            if success {
                self.favoriteProductIDs.insert(product.id)
                cell.isFavorited = true
            }
            let product = products[indexPath.item]
            let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        favCRUD.saveItem(favId: favId!, itemId: product.id ?? 0, itemImg: product.image?.src ?? "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402", itemName: product.title ?? "", itemPrice: Double(product.variants?[0]?.price ?? "") ?? 70.0)
            //print("save to favorite for product id: \(product.id)")
        favoriteProductIDs.insert(product.id ?? 0)
            cell.isFavorited = true
            
            completion()
        }
        //print("save to favorite for product id: \(product.id)")
    }

    func deleteFavoriteTapped(for cell: ProductCollectionCell, completion: @escaping() -> Void) {
        guard let indexPath = cell.indexPath else {
            print("No index path found for cell")
            completion()
            return
        }
        let product = products[indexPath.item]
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        favCRUD.deleteItem(favId: favId!, itemId: product.id) { success in
            if success {
                self.favoriteProductIDs.remove(product.id)
                cell.isFavorited = false
            }
            let product = products[indexPath.item]
            let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
            favCRUD.deleteItem(favId: favId!, itemId: product.id ?? 0)
            favoriteProductIDs.remove(product.id ?? 0)
            cell.isFavorited = false
            //fetchFavoriteItems()
    //        products.remove(at: indexPath.item)
    //        collectionView.reloadData()
            
           // print("Deleted favorite for product id: \(product.id)")
            completion()
        }
        //fetchFavoriteItems()
        //        products.remove(at: indexPath.item)
        //        collectionView.reloadData()
        
        // print("Deleted favorite for product id: \(product.id)")
    }
    
    func goToDetails(item cell: ProductCollectionCell){
        let selectedProduct = viewModel.getProducts()[cell.indexPath?.row ?? 0]

        let isFavorited = favoriteProductIDs.contains(selectedProduct.id ?? 0)
    
        coordinator?.goToProductInfo(productId: selectedProduct.id ?? 0, isFav: isFavorited)
}

}

extension CategoryViewController: UISearchBarDelegate {
    
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
