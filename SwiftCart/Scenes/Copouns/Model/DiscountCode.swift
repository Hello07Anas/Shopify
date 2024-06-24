//
//  Discount.swift
//  SwiftCart
//
//  Created by Israa on 23/06/2024.
//

import Foundation

struct DiscountCode: Codable {
    let id: Int
    let price_rule_id: Int
    let code: String
    let usage_count: Int
    let created_at: String
    let updated_at: String
}

struct DiscountCodesResponse: Codable {
    let discount_codes: [DiscountCode]

}
