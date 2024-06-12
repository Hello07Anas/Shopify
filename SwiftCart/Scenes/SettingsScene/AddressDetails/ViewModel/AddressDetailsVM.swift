//
//  AddressDetailsVM.swift
//  SwiftCart
//
//  Created by Israa on 11/06/2024.
//

import Foundation
import RxSwift

class AddressDetailsVM {
    
    private let disposeBag = DisposeBag()
    var addressDetails :  Address?
    var isUpdate = false
    var bindAddress : (()-> Void) = {}
    var alreadyFound : (()-> Void) = {}

    
    init(addressDetails: Address, isUpdate: Bool = false) {
        self.addressDetails = addressDetails
        self.isUpdate = isUpdate
    }
    
    func addNewAddress(firstName : String , lastName : String , address1 : String , city : String, phone : String){
        let customerID = K.Shopify.userID
                let endpoint = K.endPoints.getOrPostAddress.rawValue.replacingOccurrences(of: "{customer_id}", with: customerID)
                let newAddress = Address(
                    firstName: firstName, lastName: lastName, address1: address1,
                    city: city,
                    country: "Egypt", phone: phone
                )
                NetworkManager.shared.post(endpoint: endpoint, body: ["address": newAddress], responseType: CustomAddress.self)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (success, message, response) in
                        if success {
                            self.bindAddress()
                            print("ViewModel: Number of addresses: \(String(describing: response))")
                        } else {
                            self.alreadyFound()
                            print("Failed to post address: \(message ?? "No error message")")
                        }
                    }, onError: { error in
                        print("Error occurred: \(error.localizedDescription)")
                    })
                    .disposed(by: disposeBag)
            }
    
    func updateAddress(firstName : String , lastName : String , address1 : String , city : String, phone : String){
        let customerID = K.Shopify.userID
        let endpoint = K.endPoints.putOrDeleteAddress.rawValue
            .replacingOccurrences(of: "{customer_id}", with: customerID)
            .replacingOccurrences(of: "{address_id}", with: String(self.addressDetails?.id ?? 0))
        print("ID \(self.addressDetails?.id ?? 0)")

        let newAddress = Address(
            firstName: firstName, lastName: lastName, address1: address1,
            city: city,
            country: "Egypt", phone: phone
        )       
        NetworkManager.shared.put(endpoint: endpoint, body:  ["address": newAddress], responseType: CustomAddress.self)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (success, message, response) in
                        if success {
                            print("Success: \(String(describing: response))")
                        } else {
                            print("Failed to put address: \(message ?? "No error message")")
                        }
                        self.bindAddress()
                    }, onError: { error in
                        print("Error occurred: \(error.localizedDescription)")
                    })
                    .disposed(by: disposeBag)
            }
    

    
}
