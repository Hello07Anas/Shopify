//
//  DraftOrder.swift
//  SwiftCart
//
//  Created by Israa on 18/06/2024.
//

import Foundation

struct DraftOrderResponseModel : Codable {
    var singleResult: DraftOrderModel?
    var result: [DraftOrderModel]?
    
    enum CodingKeys: String, CodingKey {
        case singleResult = "draft_order"
        case result = "draft_orders"
    }
}

struct DraftOrderModel: Codable {
    let id: Int
    let currency: String
    var lineItems: [LineItem]
    var totalPrice, subtotalPrice: String
    var appliedDiscount: AppliedDiscount?

    enum CodingKeys: String, CodingKey {
        case id
        case currency
        case lineItems = "line_items"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case appliedDiscount = "applied_discount"

    }
}

struct AppliedDiscount: Codable {
    var description, value, title, amount: String
    var valueType: String

    enum CodingKeys: String, CodingKey {
        case description, value, title, amount
        case valueType = "value_type"
    }
}
