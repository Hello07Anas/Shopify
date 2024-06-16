//
//  ProductInfoVM.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//
import Foundation
import RxSwift

class ProductInfoVM {
    
    private var product: ShopifyProduct?
    private let networkManager = NetworkManager.shared
    private let disposeBag = DisposeBag()
    
    let productObservable = PublishSubject<ShopifyProduct>()

    func fetchProduct(with id: Int) {
        let endpoint = "/products/\(id).json"
        networkManager.get(endpoint: endpoint)
            .map { (response: ShopifyProductResponse) -> ShopifyProduct in
                return response.product
            }
            .subscribe(onNext: { [weak self] product in
                self?.product = product
                self?.productObservable.onNext(product)
                //print("Product fetched successfully:", product)
            }, onError: { error in
                print("Error fetching product: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }

    func getProduct() -> ShopifyProduct? {
        return product
    }
}
