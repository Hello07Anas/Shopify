//
//  ProfileViewController.swift
//  SwiftCart
//
//  Created by Israa on 17/06/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var FavCollectionView: UICollectionView!
    weak var coordinator: AppCoordinator?
    var orderViewModel = OrderViewModel()
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var ProductNum: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!


    var productsList: [ProductDumy] = []
    var products: [ProductDumy] = []
    let favCRUD = FavCRUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        orderViewModel.getOrdersList(completion: { [self]_ in
            
            let orderDetails = self.orderViewModel.getFirstOrder()
            print(orderDetails)
            
            ProductNum.text = "\(orderDetails?.productNumber ?? "")"
            orderNum.text = "\(orderDetails?.orderNumber! ?? 0)"
            self.address.text = "\(String(describing: orderDetails?.address!.address1 ?? "")) \(String(describing: orderDetails?.address!.city ?? ""))"
            
            date.text = Utils.extractDate(from:  orderDetails?.date ?? "2024-05-27T08:25:00-04:00")
            //TODO: formatAsCurrency
            price.text = "\(orderDetails?.totalPrice ?? "")  \(orderDetails?.currency.rawValue ?? "")"
        })
        FavCollectionView.register(UINib(nibName: "ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")

        FavCollectionView.delegate = self
        FavCollectionView.dataSource = self
        setupOrderView()
        setupUserView()
        setupCollectionViewLayout()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoriteItems()
        userName.text = "Welcome, \(String(describing: UserDefaultsHelper.shared.getUserData().name ?? ""))👋"
        email.text = UserDefaultsHelper.shared.getUserData().email
     
        
    }

    private func fetchFavoriteItems() {
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        favCRUD.readItems(favId: favId!) { [weak self] lineItems in
            DispatchQueue.main.async {
                // Map lineItems to ProductDumy
                self?.productsList = lineItems.map { lineItem -> ProductDumy in
                    let image = lineItem.properties.first?["value"] ?? ""
                    let isFavorited = true
                    return ProductDumy(name: lineItem.title, price: lineItem.price, imageName: image, isFavorited: isFavorited, itemId: lineItem.id!)
                }
                
                // Ensure products array is not out of range
                if self?.productsList.count ?? 0 >= 4 {
                    self?.products = Array(self?.productsList.prefix(4) ?? [])
                } else {
                    self?.products = self?.productsList ?? []
                }
                self?.FavCollectionView.reloadData()
            }
        }
    }

    @IBAction func gotoSettings(_ sender: Any) {
        coordinator?.goToSettings()
    }

    @IBAction func showOrderList(_ sender: Any) {
        coordinator?.goToOrders()
    }

    @IBAction func showWishlist(_ sender: Any) {
        coordinator?.goToFav()
    }

    private func setupOrderView() {
        orderView.layer.borderColor = UIColor.black.cgColor
        orderView.layer.borderWidth = 1.0
        orderView.layer.cornerRadius = 10.0
        orderView.layer.masksToBounds = true
    }

    private func setupUserView() {
        userView.layer.borderColor = UIColor.black.cgColor
        userView.layer.borderWidth = 0.0
        userView.layer.cornerRadius = 10.0
        userView.layer.masksToBounds = true
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ProductCollectionCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionCell
        let product = products[indexPath.item]
        cell.configure(with: product, isFavorited: true)
        cell.isCellNowFav = true
        cell.delegate = self
        cell.indexPath = indexPath
        cell.setBtnImg()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let sectionInset: CGFloat = 10
        let totalSpacing = sectionInset * 2 + spacing
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: 150)
    }
    
    func deleteFavoriteTapped(for cell: ProductCollectionCell, completion: @escaping () -> Void) {
        guard let indexPath = cell.indexPath else { return }
        
        var product = products[indexPath.item]
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        
        
        favCRUD.deleteItem(favId: favId!, itemId: product.itemId) { success in
            if success {
                product.isFavorited.toggle()
                self.products.remove(at: indexPath.item)
                
                if let indexInList = self.productsList.firstIndex(where: { $0.itemId == product.itemId }) {
                    self.productsList.remove(at: indexInList)
                }
                
                if self.productsList.count  >= 4 {
                    self.products = Array(self.productsList.prefix(4) )
                } else {
                    self.products = self.productsList
                    
                    self.FavCollectionView.reloadData()
                }
            }
                completion()
                
            
        }
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
        FavCollectionView.collectionViewLayout = layout
    }
    
    
    func goToDetails(item cell: ProductCollectionCell) {
        let product = products[cell.indexPath?.item ?? 0]
        coordinator?.goToProductInfo(productId: product.itemId, isFav: product.isFavorited)
    }
}

