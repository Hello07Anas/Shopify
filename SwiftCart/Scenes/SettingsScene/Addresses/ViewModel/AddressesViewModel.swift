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
    var network : NetworkManager?
    var bindAddresses : (()-> Void) = {}
        
    init(network: NetworkManager) {
        self.network = network
    }
    
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
        let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/customers/6930899632175/addresses.json"
        
        network?.getApiData(url: url)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                print("ViewModel: Received addresses response")
                if let userAddresses: userAddress = Utils.convertTo(from: data) {
                    self?.addressesList = userAddresses.addresses 
                    self?.addressesSubject.onNext(self?.addressesList ?? [])
                    self?.bindAddresses()
                    print("ViewModel: Number of addresses: \(String(describing: self?.addressesList?.count))")

                        } else {
                    print("loadData ")
                }
            }, onError: { error in
                print("ViewModel: API Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
    }
    
    func deleteAddress(index:Int){
             // TODO: handle delete
    }
}
