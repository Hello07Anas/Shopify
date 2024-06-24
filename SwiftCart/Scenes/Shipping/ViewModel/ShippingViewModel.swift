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
    
    var priceBeforeDiscount : String!
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
                    self?.priceBeforeDiscount = response.singleResult?.subtotalPrice ?? ""
                    self?.bindShipping()
                } else {
                    print("ViewModel: No items in cart")
                }
                
            }, onError: { (error: Error) in
                print("Error occurred: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func applyPromoCode(promocode: String) {
            let endpoint = K.endPoints.discountLocation.rawValue.replacingOccurrences(of: "{discount_code}", with: promocode)
            
            network?.get(endpoint: endpoint)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (response: DiscountCodesResponse) in
                    guard let discountCode = response.discount_codes.first else {
                        print("No discount codes found")
                        return
                    }
                    
                    self?.getPriceRuleDetails(priceRuleId: discountCode.price_rule_id, promocode: promocode)
                    
                }, onError: { (error: Error) in
                    print("Error occurred: \(error.localizedDescription)")
                })
                .disposed(by: disposeBag)
        }
        
        private func getPriceRuleDetails(priceRuleId: Int, promocode: String) {
            let endpoint = K.endPoints.priceRule.rawValue.replacingOccurrences(of: "{price_rule_id}", with: String(priceRuleId))
            
            network?.get(endpoint: endpoint)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (response: PriceRuleResponse) in
                    self?.applyDiscount(priceRule: response.priceRule, promocode: promocode)
                    
                }, onError: { (error: Error) in
                    print("Error occurred: \(error.localizedDescription)")
                })
                .disposed(by: disposeBag)
        }
        
        private func applyDiscount(priceRule: PriceRule, promocode: String) {
            guard var draftOrder = draftOrder?.singleResult else { return }
            
            let discountValue = Double(priceRule.value) ?? 0.0
            let totalPrice = Double(draftOrder.totalPrice) ?? 0.0
            let discountedPrice = totalPrice + discountValue // Assuming the discount value is negative
            
            let appliedDiscount = AppliedDiscount(
                description: priceRule.title,
                value: priceRule.value,
                title: promocode,
                amount: String(discountValue),
                valueType: priceRule.valueType
            )
            
            draftOrder.totalPrice = String(discountedPrice)
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
                        self?.bindShipping()
                    } else {
                        print("Failed to update cart: \(message ?? "No error message")")
                    }
                }, onError: { error in
                    print("Error occurred: \(error.localizedDescription)")
                })
                .disposed(by: disposeBag)
        }
    }
