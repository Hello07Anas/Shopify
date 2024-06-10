//
//  ProductInfoVM.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import Foundation

class ProductInfoVM {
    
    private var product: Product
    
    init(product: Product) {
        self.product = product
//        print("-------------------")
//        print(product)
    }
    
    func getProduct() -> Product {
        return product
    }
}
