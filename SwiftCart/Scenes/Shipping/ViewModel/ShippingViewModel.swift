//
//  ShippingViewModel.swift
//  SwiftCart
//
//  Created by Israa on 23/06/2024.
//

import Foundation
import RxSwift

class ShippingViewModel {
    var network: NetworkManager?
    var draftOrder: DraftOrderResponseModel?
    var cartProductsList: [LineItem]?
    let disposeBag = DisposeBag()
    var bindShipping: (() -> Void) = {}
    var GrandPrice : String!
    init(network: NetworkManager?) {
        self.network = network
    }
    
    func getCartProductsList() {
        let cartID = UserDefaultsHelper.shared.getUserData().cartID ?? ""
        let endpoint = K.endPoints.draftOrders.rawValue.replacingOccurrences(of: "{draft_orders_id}", with: cartID)
        network?.get(endpoint: endpoint)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (response: DraftOrderResponseModel) in
                if let lineItems = response.singleResult?.lineItems {
                    _ = lineItems.filter { item in
                        return item.variantID != nil
                    }
                    self?.draftOrder = response
                    self?.GrandPrice = response.singleResult?.totalPrice ?? ""
                    self?.bindShipping()
                } else {
                    print("ViewModel: No items in cart")
                }
                
            }, onError: { (error: Error) in
                print("Error occurred: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    

        func getPriceRuleDetails(promocode: String) {
            let endpoint = K.endPoints.priceRule.rawValue
            
            network?.get(endpoint: endpoint)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (response: PriceRulesResponse) in
    
                    for discount in response.priceRules {
                        if promocode == discount .title {
                            self?.applyDiscount(priceRule: discount)
                        }
                    }
                }, onError: { (error: Error) in
                    print("Error occurred: \(error.localizedDescription)")
                })
                .disposed(by: disposeBag)
        }
        
        private func applyDiscount(priceRule: PriceRule) {
            guard var draftOrder = draftOrder?.singleResult else { return }
            
            var value = priceRule.value
            if value.hasPrefix("-") { value.removeFirst() }
            let appliedDiscount = AppliedDiscount(
                description: "Custom",
                value: value,
                title: priceRule.title,
                amount: value,
                valueType: priceRule.valueType
            )
            

            draftOrder.appliedDiscount = appliedDiscount
            
            updateDraftOrder(draftOrder: draftOrder)
        }
        
        private func updateDraftOrder(draftOrder: DraftOrderModel) {
            let cartID = UserDefaultsHelper.shared.getUserData().cartID!
            let endpoint = K.endPoints.draftOrders.rawValue.replacingOccurrences(of: "{draft_orders_id}", with: cartID)
            
            network?.put(endpoint: endpoint, body: DraftOrderResponseModel(singleResult: draftOrder), responseType: DraftOrderResponseModel.self)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (success, message, response) in
                    if success {
                        print("Success: \(String(describing: response))")
                        self?.draftOrder = response
                    } else {
                        print("Failed to update cart: \(message ?? "No error message")")
                    }
                }, onError: { error in
                    print("Error occurred: \(error.localizedDescription)")
                })
                .disposed(by: disposeBag)
        }
    
    
    func deleteLineItems() {
        guard let cartID = UserDefaultsHelper.shared.getUserData().cartID else {
            print("Error: Cart ID is nil")
            return
        }
        
        let endpoint = K.endPoints.draftOrders.rawValue.replacingOccurrences(of: "{draft_orders_id}", with: cartID)
        
        let newLineItem = LineItem(
            id: 0,
            variantID: nil,
            quantity: 1, 
            properties: [LineItem.Property(name: "image", value: "")],
            productID: nil,
            productTitle: "Default Title",
            productVendor: "Default Vendor",
            productPrice: "0.00",
            sizeColor: "Default Size/Color"
        )
        
        draftOrder?.singleResult?.lineItems.removeAll()
        
        draftOrder?.singleResult?.lineItems.append(newLineItem)
            if let draftOrder = draftOrder {
            do {
                let jsonData = try JSONEncoder().encode(draftOrder)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Request Payload: \(jsonString)")
                }
            } catch {
                print("Failed to encode draftOrder: \(error.localizedDescription)")
                return
            }
        } else {
            print("Error: draftOrder is nil")
            return
        }
        
        network?.put(endpoint: endpoint, body: draftOrder, responseType: DraftOrderResponseModel.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (success, message, response) in
                if success {
                    print("Success: \(String(describing: response))")
                } else {
                    print("Failed to delete cart: \(message ?? "No error message")")
                    if let response = response {
                        print("Response details: \(response)")
                    }
                }
            }, onError: { error in
                print("Error occurred: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    }
