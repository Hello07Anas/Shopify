//
//  OrderViewModel.swift
//  SwiftCart
//
//  Created by Elham on 20/06/2024.
//

import Foundation
import RxSwift

class OrderViewModel{
    
    private let ordersSubject = PublishSubject<[Order]>()
    var orderObservable: Observable<[Order]> {
        return ordersSubject.asObservable()
    }
    private let disposeBag = DisposeBag()
    var ordersList : [Order]?
    var bindOrder : (()-> Void) = {}
    var ordersUpdated: ((Bool) -> Void)?

    func getOrders() -> [Order] {
        return ordersList ?? []
    }
    func getFirstOrder() -> Order {
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

        return ordersList?[0] ?? testOrder
    }
    
    func getOrdersCount() -> Int {
        return ordersList?.count ?? 0
    }
    
    func getOrderByIndex(index:Int) ->  Order{
        return (ordersList?[index])!
    }
    
//    func getOrdersList() {
//        
//        let customerID = K.Shopify.userID
//        let endpoint = "orders.json?customer_id=\(customerID)"
//        NetworkManager.shared.get(endpoint: endpoint)
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [weak self] (response: OrdersResponse) in
//                self?.ordersList = response.orders
//                self?.ordersSubject.onNext(self?.ordersList ?? [])
//                self?.bindOrder()
//                print("ViewModel: Number of orders: \(String(describing: self?.ordersList?.count))")
//            }, onError: { (error: Error) in
//                print("Error occurred: \(error.localizedDescription)")
//            })
//            .disposed(by: disposeBag)
//        
//        
//        
//    }
    
    func getOrdersList(completion: @escaping (Int?) -> Void) {
            let customerID = K.Shopify.userID
            let endpoint = "orders.json?customer_id=7105857716271"
            NetworkManager.shared.get(endpoint: endpoint)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (response: OrdersResponse) in
                    self?.ordersList = response.orders
                    self?.ordersSubject.onNext(self?.ordersList ?? [])
                    self?.bindOrder()
                    self?.ordersUpdated?(self?.ordersList?.isEmpty == false)
                    print("ViewModel: Number of orders: \(String(describing: self?.ordersList?.count))")
                }, onError: { (error: Error) in
                    print("Error occurred: \(error.localizedDescription)")
                })
                .disposed(by: disposeBag)
        }

    
    
//    func addNewOrder(newOrder:OrderResponse){
//                let endpoint = "orders.json"
//                NetworkManager.shared.post(endpoint: endpoint, body: ["order": newOrder], responseType: OrderResponse.self)
//                    .observeOn(MainScheduler.instance)
//                    .subscribe(onNext: { (success, message, response) in
//                        if success {
//                            self.bindOrder()
//                            print("OrderViewModel: Number of Order: \(String(describing: response))")
//                        } else {
//                            print("Failed to post order: \(message ?? "No error message")")
//                            print(newOrder)
//                        }
//                    }, onError: { error in
//                        print("Error occurred: \(error.localizedDescription)")
//                    })
//                    .disposed(by: disposeBag)
//            }

    func addNewOrder(newOrder: Order) {
           let endpoint = "orders.json"  // Corrected endpoint path
           let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/"
        print(newOrder)
           do {
               let encoder = JSONEncoder()
               encoder.dateEncodingStrategy = .iso8601
               let orderData = try encoder.encode(newOrder)
               if let orderDict = try JSONSerialization.jsonObject(with: orderData, options: .mutableContainers) as? [String: Any] {
                   NetworkManager.shared.postOrder(url: url, endpoint: endpoint, body: ["order": orderDict])
                       .observeOn(MainScheduler.instance)
                       .subscribe(onNext: { (success, message, response) in
                           if success {
                               print("Order posted successfully: \(String(describing: response))")
                           } else {
                               print("Failed to post order: \(message ?? "No error message")")
                           }
                       }, onError: { error in
                           print("Error occurred: \(error.localizedDescription)")
                       })
                       .disposed(by: disposeBag)
               }
           } catch {
               print("Failed to encode order: \(error.localizedDescription)")
           }
       }
    
}
