//
//  CartViewModel.swift
//  SwiftCart
//
//  Created by Israa on 17/06/2024.
//

import Foundation
import RxSwift

class CartViewModel{
    
    let network : NetworkManager?
    private let cartSubject = PublishSubject<[LineItem]>()
    var cartObservable: Observable<[LineItem]> {
        return cartSubject.asObservable()
    }
    private let disposeBag = DisposeBag()
    var cartProductsList : [LineItem]?
    var draftOrder : DraftOrderResponseModel?
    var bindCartProducts : (()-> Void) = {}
    
    init(network: NetworkManager?) {
        self.network = network
    }
    
    func getCartProducts() -> [LineItem] {
        return cartProductsList ?? []
    }
    
    func getCartProductCount() -> Int {
        return cartProductsList?.count ?? 0
    }
    
    func getCartProductByIndex(index:Int) ->  LineItem{
        return (cartProductsList?[index])!
    }
    
    func getCartProductsList() {
        
        let cartID = UserDefaultsHelper.shared.getUserData().cartID!
        let endpoint = K.endPoints.draftOrders.rawValue.replacingOccurrences(of: "{draft_orders_id}", with: cartID)
        network?.get(endpoint: endpoint)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (response: DraftOrderResponseModel) in
                if let lineItems = response.singleResult?.lineItems {
                    let filteredLineItems = lineItems.filter { item in
                        return item.variantID  != nil
                    }
                    self?.draftOrder = response
                    self?.cartProductsList = filteredLineItems
                    self?.cartSubject.onNext(self?.cartProductsList ?? [])
                    self?.bindCartProducts()
                    print("ViewModel: Number of CartProducts: \(String(describing: self?.cartProductsList))")
                } else {
                    print("ViewModel: No items in cart")
                }
                
            }, onError: { (error: Error) in
                print("Error occurred: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func deletePrduct( id : Int){
        draftOrder?.singleResult?.lineItems.removeAll(where:  { $0.variantID == id })
        cartProductsList?.removeAll(where:  { $0.variantID == id })
        let cartID = UserDefaultsHelper.shared.getUserData().cartID!
        let endpoint = K.endPoints.draftOrders.rawValue.replacingOccurrences(of: "{draft_orders_id}", with: cartID)
        
        network?.put(endpoint: endpoint, body: draftOrder, responseType: DraftOrderResponseModel.self)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { (success, message, response) in
                            if success {
                                print("Success: \(String(describing: response))")
                            } else {
                                print("Failed to put address: \(message ?? "No error message")")
                            }
                            self.cartSubject.onNext(self.cartProductsList ?? [])
                            self.bindCartProducts()
                        }, onError: { error in
                            print("Error occurred: \(error.localizedDescription)")
                        })
                        .disposed(by: disposeBag)
    }
        
    func configCell(_ cell: ProductCartCell, at index: Int) {
        guard let product = cartProductsList?[index] else {
            return
        }
        cell.setProduct(product)
        cell.setCell(id: product.variantID ?? -1)
        cell.setImage(with: product.properties.first { $0.name == "image" }?.value)
    }

}
