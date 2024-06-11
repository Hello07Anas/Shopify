//
//  AddressesViewModel.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import Foundation
import RxSwift

class AddressesViewModel{
    
    private let addressesSubject = PublishSubject<[Address]>()
    var addressesObservable: Observable<[Address]> {
        return addressesSubject.asObservable()
    }
    private let disposeBag = DisposeBag()
    var addressesList : [Address]?
    var bindAddresses : (()-> Void) = {}
    
    func getAddresses() -> [Address] {
        return addressesList ?? []
    }
    
    func getAddresesCount() -> Int {
        return addressesList?.count ?? 0
    }
    
    func getAddressByIndex(index:Int) ->  Address{
        return (addressesList?[index])!
    }
    
    func getAddressesList() {
        
        let customerID = K.Shopify.userID
        let endpoint = K.endPoints.getOrPostAddress.rawValue.replacingOccurrences(of: "{customer_id}", with: customerID)
        NetworkManager.shared.get(endpoint: endpoint)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (response: userAddress) in
                self?.addressesList = response.addresses
                self?.addressesSubject.onNext(self?.addressesList ?? [])
                self?.bindAddresses()
                print("ViewModel: Number of addresses: \(String(describing: self?.addressesList?.count))")
            }, onError: { (error: Error) in
                print("Error occurred: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
    
        
    }
    
    func deleteAddress(index: Int) {
        let customerId = K.Shopify.userID
        let endpoint = K.endPoints.putOrDeleteAddress.rawValue
            .replacingOccurrences(of: "{customer_id}", with: customerId)
            .replacingOccurrences(of: "{address_id}", with: String(addressesList?[index].id ?? 0))
        
        NetworkManager.shared.delete(endpoint: endpoint)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] statusCode in
                print("Delete request successful with status code: \(statusCode)")
                self?.addressesList?.remove(at: index)
                self?.addressesSubject.onNext(self?.addressesList ?? [])
                self?.bindAddresses()
            }, onError: { error in
                print("Error deleting address: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    }

