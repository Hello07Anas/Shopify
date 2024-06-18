//
//  DraftOrder.swift
//  SwiftCart
//
//  Created by Israa on 18/06/2024.
//

import Foundation

struct DraftOrderResponseModel : Decodable {
    let singleResult: DraftOrderModel?
    let result: [DraftOrderModel]?
    
    enum CodingKeys: String, CodingKey {
        case singleResult = "draft_order"
        case result = "draft_orders"
    }
}

struct DraftOrderModel: Codable {
    let id: Int
    let currency: String
    let lineItems: [LineItem]
    let totalPrice: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case currency
        case lineItems = "line_items"
        case totalPrice = "total_price"
    }
}
