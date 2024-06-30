//
//  Variant.swift
//  SwiftCart
//
//  Created by Israa on 18/06/2024.
//

struct VarientData : Codable {
    var variant: VariantModel?
}

struct VariantModel: Codable {
    var id: Int64?
    var product_id: Int64?
    var title: String?
    var price: String?
    var position: Int?
    var inventory_policy: String?
    var inventory_management: String?
    var inventory_quantity: Int?
    var old_inventory_quantity: Int?
}


