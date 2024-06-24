//
//  Discount.swift
//  SwiftCart
//
//  Created by Israa on 23/06/2024.
//

import Foundation

struct DiscountCodeResponse: Codable {
    let discountCodes: [DiscountCode]

    enum CodingKeys: String, CodingKey {
        case discountCodes = "discount_codes"
    }
}

// MARK: - DiscountCode
struct DiscountCode: Codable {
    let id, priceRuleID: Int
    let code: String
    let usageCount: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case priceRuleID = "price_rule_id"
        case code
        case usageCount = "usage_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
