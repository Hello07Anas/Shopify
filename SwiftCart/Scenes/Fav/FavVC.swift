//
//  FavVC.swift
//  SwiftCart
//
//  Created by Anas Salah on 11/06/2024.
//

import UIKit

struct ProductDumy {
    let name: String
    let price: String
    let imageName: String
    var isFavorited: Bool
    let itemId: Int
    
    init(name: String, price: String, imageName: String, isFavorited: Bool = false, itemId: Int) {
        self.name = name
        self.price = price
        self.imageName = imageName
        self.isFavorited = isFavorited
        self.itemId = itemId
    }
}

class FavVC: UIViewController {

    var coordinator: AppCoordinator?
    var products: [ProductDumy] = []
    let favCRUD = FavCRUD()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchFavoriteItems()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setupCollectionViewLayout()
        
    }

    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }

    private func fetchFavoriteItems() {
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        favCRUD.readItems(favId: favId!) { [weak self] lineItems in
            DispatchQueue.main.async {
                // Map lineItems to ProductDumy
                self?.products = lineItems.map { lineItem -> ProductDumy in
                    let image = lineItem.properties.first?["value"] ?? ""
                    let isFavorited = true
                    return ProductDumy(name: lineItem.title, price: lineItem.price, imageName: image, isFavorited: isFavorited, itemId: lineItem.id!)
                }
                self?.collectionView.reloadData()
            }
        }
    }

}

extension FavVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let product = products[indexPath.item]
//        print("Selected product itemId: \(product.itemId)")
//        coordinator?.goToProductInfo(productId: product.itemId, isFav: product.isFavorited)
//        //print("===============");print(product.isFavorited);print("===============")
//    }
}

extension FavVC: ProductCollectionCellDelegate {
    func saveToFavorite(foe cell: ProductCollectionCell) {
        print("")
    }
    

    func deleteFavoriteTapped(for cell: ProductCollectionCell) {
        guard let indexPath = cell.indexPath else {
            return
        }

        var product = products[indexPath.item]
        let favId = Int(UserDefaultsHelper.shared.getUserData().favID ?? "0")
        
        favCRUD.deleteItem(favId: favId!, itemId: product.itemId)

        product.isFavorited.toggle()
        products[indexPath.item] = product
        products.remove(at: indexPath.item)

        collectionView.reloadData()
        
        //print("ProductCollectionCellDelegate - IndexPath: \(indexPath)")
        //print("===---===ProductCollectionCellDelegate"); print(favId as Any)
        //print("ProductCollectionCellDelegate===---==="); print("ProductCollectionCellDelegate")
    }
    func goToDetails(item cell: ProductCollectionCell){
        let product = products[cell.indexPath?.item ?? 0]
        print("Selected product itemId: \(product.itemId)")
        coordinator?.goToProductInfo(productId: product.itemId, isFav: product.isFavorited)
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
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
