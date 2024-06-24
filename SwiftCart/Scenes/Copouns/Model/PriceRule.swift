//
//  PriceRule.swift
//  SwiftCart
//
//  Created by Israa on 23/06/2024.
//

import Foundation

struct PriceRule: Codable {
    let id: Int
    let valueType: String
    let value: String
    let customerSelection: String
    let targetType: String
    let targetSelection: String
    let allocationMethod: String
    let usageLimit: Int?
    let startsAt: String
    let endsAt: String
    let createdAt: String
    let updatedAt: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case valueType = "value_type"
        case value
        case customerSelection = "customer_selection"
        case targetType = "target_type"
        case targetSelection = "target_selection"
        case allocationMethod = "allocation_method"
        case usageLimit = "usage_limit"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title
    }
}

struct PriceRuleResponse: Codable {
    let priceRule: PriceRule

    enum CodingKeys: String, CodingKey {
        case priceRule = "price_rule"
    }
}
