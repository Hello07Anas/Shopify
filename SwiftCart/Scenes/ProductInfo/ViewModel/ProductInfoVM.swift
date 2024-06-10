//
//  ProductInfoVM.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import Foundation

class ProductInfoVM {
    
    typealias Product = Any
    private var product: Product // TODO: resive data from elham here
    
    init(product: Product) {
        self.product = product
    }
    
    func getProduct() -> Product {
        
        return product
    }
}
