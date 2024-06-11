//
//  AddressDetailsVM.swift
//  SwiftCart
//
//  Created by Israa on 11/06/2024.
//

import Foundation

class AddressDetailsVM {
    var addressDetails :  Address?
    var isUpdate = false
    
    init(addressDetails: Address, isUpdate: Bool = false) {
        self.addressDetails = addressDetails
        self.isUpdate = isUpdate
    }
}
