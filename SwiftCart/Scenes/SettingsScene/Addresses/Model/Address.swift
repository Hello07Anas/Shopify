//
//  Address.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import Foundation

struct Address: Codable {
    var id : Int?
    var customerID : Int?
    var firstName : String?
    var lastName : String?
    var address1 : String?
    var city : String?
    var country : String?
    var phone : String?
    var isDefault : Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case customerID = "customer_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case isDefault = "default"
        case  address1, city, country, phone
    }
    
}

struct CustomAddress : Codable{
    var customer_address  : Address
}

struct AddressObject : Codable {
    var address : Address
}

class userAddress : Codable {
    var addresses : [Address]
    
    init(addresses: [Address]) {
        self.addresses = addresses
    }
}
