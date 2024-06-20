//
//  Currency.swift
//  SwiftCart
//
//  Created by Israa on 19/06/2024.
//

import Foundation

struct Currency : Codable{
    var data : Data
}

struct Data : Codable {
    var EGP : Target
}

struct Target : Codable{
    var code:String
    var value:Double
}
