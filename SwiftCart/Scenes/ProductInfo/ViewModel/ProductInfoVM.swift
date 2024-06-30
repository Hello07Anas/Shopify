//
//  ProductInfoVM.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//
import UIKit
import RxSwift

class ProductInfoVM {
    
    private var product: ShopifyProduct?
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    let productObservable = PublishSubject<ShopifyProduct>()
    let colorsObservable = PublishSubject<[String]>()
    let sizesObservable = PublishSubject<[String]>()
    
    var colorsDictionary: [String: UIColor] = [
        "black": .black,
        "white": .white,
        "red": .red,
        "green": .green,
        "blue": .blue,
        "yellow": .yellow,
        "orange": .orange,
        "purple": .purple,
        "brown": .brown,
        "cyan": .cyan,
        "magenta": .magenta,
        "gray": .gray
    ]
    func fetchProduct(with id: Int) {
        let endpoint = "/products/\(id).json"
        networkManager.get(endpoint: endpoint)
            .map { (response: ShopifyProductResponse) -> ShopifyProduct in
                return response.product
            }
            .subscribe(onNext: { [weak self] product in
                self?.product = product
                self?.productObservable.onNext(product)
                self?.extractColorsAndSizes(from: product.variants ?? [])
                //print("Product fetched successfully:", product)
            }, onError: { error in
                print("Error fetching product: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func getProduct() -> ShopifyProduct? {
        return product
    }
    
    private func extractColorsAndSizes(from variants: [ShopifyProductVariant]) {
        let colors = Set(variants.compactMap { $0.option2 })
        let sizes = Set(variants.compactMap { $0.option1 })
        
        colorsObservable.onNext(Array(colors))
        sizesObservable.onNext(Array(sizes))
        
        for color in colors {
            colorsDictionary[color] = UIColor(named: color) ?? .black
        }
    }
}
