//
//  Currency.swift
//  SwiftCart
//
//  Created by Israa on 19/06/2024.
//

import Foundation

struct Currency: Codable {
    var meta: Meta
    var data: [String: CurrencyData]
    
    struct Meta: Codable {
        var last_updated_at: String
    }
}

struct CurrencyData: Codable {
    var code: String
    var value: Double
}
