//
//  ShippingViewModel.swift
//  SwiftCart
//
//  Created by Israa on 23/06/2024.
//

import Foundation
import RxSwift

class ShippingViewModel {
    let network: NetworkManager?
    private let disposeBag = DisposeBag()
    var draftOrder: DraftOrderResponseModel?
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
}
