//
//  CartViewModel.swift
//  SwiftCart
//
//  Created by Israa on 17/06/2024.
//

import Foundation
import RxSwift

class CartViewModel {
    
    let network: NetworkManager?
    private let cartSubject = PublishSubject<[LineItem]>()
    var cartObservable: Observable<[LineItem]> {
        return cartSubject.asObservable()
    }
    private let disposeBag = DisposeBag()
    var cartProductsList: [LineItem]?
    var draftOrder: DraftOrderResponseModel?
    var bindDoneOperation: (() -> Void) = {}
    var bindCartProducts: (() -> Void) = {}
    var bindMaxLimitQuantity: (() -> Void) = {}
    var productAlreadyExist: (() -> Void) = {}
    var productSoldOut: (() -> Void) = {}
    var updateTotalPrice: ((String) -> Void)?
    var bindErrorOperation:(() -> Void) = {}

    
    init(network: NetworkManager?) {
        self.network = network
    }
    
    func getCartProducts() -> [LineItem] {
        return cartProductsList ?? []
    }
    
    func getCartProductCount() -> Int {
        return cartProductsList?.count ?? 0
    }
    
    func getCartProductByIndex(index: Int) -> LineItem {
        return (cartProductsList?[index])!
    }
    
    func getCartProductsList() {
        let cartID = UserDefaultsHelper.shared.getUserData().cartID ?? ""
        let endpoint = K.endPoints.draftOrders.rawValue.replacingOccurrences(of: "{draft_orders_id}", with: cartID)
        network?.get(endpoint: endpoint)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (response: DraftOrderResponseModel) in
                if let lineItems = response.singleResult?.lineItems {
                    let filteredLineItems = lineItems.filter { item in
                        return item.variantID != nil
                    }
                    self?.draftOrder = response
                    self?.cartProductsList = filteredLineItems
                    self?.cartSubject.onNext(self?.cartProductsList ?? [])
                    self?.bindCartProducts()
                        self?.updateTotalPrice?(response.singleResult?.totalPrice ?? "0.0")
                } else {
                    print("ViewModel: No items in cart")
                }
                                
            }, onError: { (error: Error) in
                print("Error occurred: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func deleteProduct(id: Int) {
        draftOrder?.singleResult?.lineItems.removeAll(where: { $0.variantID == id })
        cartProductsList?.removeAll(where: { $0.variantID == id })
        let cartID = UserDefaultsHelper.shared.getUserData().cartID!
        let endpoint = K.endPoints.draftOrders.rawValue.replacingOccurrences(of: "{draft_orders_id}", with: cartID)
        
        network?.put(endpoint: endpoint, body: draftOrder, responseType: DraftOrderResponseModel.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (success, message, response) in
                if success {
                    print("Success: \(String(describing: response))")
                } else {
                    print("Failed to update cart: \(message ?? "No error message")")
                }
                self.getCartProductsList()
            }, onError: { error in
                print("Error occurred: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    private func checkInventoryQuantity(quantity: Int, forVariantID variantID: Int, completion: @escaping (Bool) -> Void) {
        let endpoint = K.endPoints.variants.rawValue.replacingOccurrences(of: "{variant_id}", with: String(variantID))
        network?.get(endpoint: endpoint)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { (response: VarientData) in
                    guard let variant = response.variant else {
                        print("no quantity")
                        completion(false)
                        return
                    }
                    
                    if let inventoryQuantity = variant.inventory_quantity {
                        let isAvailable = (quantity <= (inventoryQuantity / 2) || inventoryQuantity == 1)
                        completion(isAvailable)
                        print("ViewModel: inventory quantity: \(inventoryQuantity) \(isAvailable)")
                    } else {
                        completion(false)
                    }
                },
                onError: { error in
                    print("Error occurred: \(error.localizedDescription)")
                    completion(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func updateLineItemQuantity(variantID: Int, newQuantity: Int) {
        self.checkInventoryQuantity(quantity: newQuantity, forVariantID: variantID) { [weak self] isAvailable in
            guard let self = self else { return }
            
            if !isAvailable {
                self.bindMaxLimitQuantity()
            } else {
                if let index = self.cartProductsList?.firstIndex(where: { $0.variantID == variantID }) {
                    self.cartProductsList?[index].quantity = newQuantity
                    self.draftOrder?.singleResult?.lineItems = self.cartProductsList ?? []
                    
                    let cartID = UserDefaultsHelper.shared.getUserData().cartID!
                    let endpoint = K.endPoints.draftOrders.rawValue.replacingOccurrences(of: "{draft_orders_id}", with: cartID)
                    
                    self.network?.put(endpoint: endpoint, body: self.draftOrder, responseType: DraftOrderResponseModel.self)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { (success, message, response) in
                            if success {
                                print("Success: \(String(describing: response))")
                            } else {
                                print("Failed to update cart: \(message ?? "No error message")")
                            }
                            self.getCartProductsList()
                        }, onError: { error in
                            print("Error occurred: \(error.localizedDescription)")
                        })
                        .disposed(by: self.disposeBag)
                }
            }
        }
    }

    func configCell(_ cell: ProductCartCell, at index: Int) {
        guard let product = cartProductsList?[index] else {
            return
        }
        cell.setProduct(product)
        cell.setCell(id: product.variantID ?? -1)
        cell.setImage(with: product.properties.first { $0.name == "image" }?.value)
        cell.delegate = self
    }
    
    
    func addNewItemLine(variantID: Int, quantity: Int, imageURLString: String, productID: Int, productTitle: String, productPrice: String) {
        self.getCartProductsList()
        
        if let _ = self.draftOrder?.singleResult?.lineItems.first(where: { $0.variantID == variantID }) {
            self.productAlreadyExist()
            return
        } else{
            
            self.checkInventoryQuantity(quantity: quantity, forVariantID: variantID) { [weak self] isAvailable in
                guard let self = self else { return }
                
                if !isAvailable {
                    self.productSoldOut()
                } else {
                    var lineItems = self.draftOrder?.singleResult?.lineItems ?? []
                    let newLineItem = LineItem(
                        id: 0,
                        variantID: variantID,
                        quantity: quantity,
                        properties: [LineItem.Property(name: "image", value: imageURLString)],
                        productID: productID,
                        productTitle: productTitle,
                        productVendor: nil,
                        productPrice: productPrice,
                        sizeColor: nil
                    )
                    lineItems.append(newLineItem)
                    self.draftOrder?.singleResult?.lineItems = lineItems
                    
                    let cartID = UserDefaultsHelper.shared.getUserData().cartID ?? ""
                    let endpoint = K.endPoints.draftOrders.rawValue.replacingOccurrences(of: "{draft_orders_id}", with: cartID)
                    
                    
                    self.network?.put(endpoint: endpoint, body: self.draftOrder, responseType: DraftOrderResponseModel.self)
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { (success, message, response) in
                                print("Success: \(String(describing: response))")
                                self.getCartProductsList()
                            
                            self.bindDoneOperation()
                        }, onError: { error in
                            print("Error occurred: \(error.localizedDescription)")
                            self.bindErrorOperation()
                        })
                        .disposed(by: self.disposeBag)
                }
            }
        }
        
    }
    }



extension CartViewModel: ProductCartCellDelegate {
    func didUpdateProductQuantity(forCellID id: Int, with quantity: Int) {
        updateLineItemQuantity(variantID: id, newQuantity: quantity)
    }
}
