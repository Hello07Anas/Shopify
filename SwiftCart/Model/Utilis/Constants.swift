//
//  Constants.swift
//  SwiftCart
//
//  Created by Anas Salah on 07/06/2024.
//

import Foundation

// MARK: This for all string in project pleas dont user strings in project

public enum K {
    
    enum Auth {
        static let SginUp_Nib_Name = "SginUp"
        static let Login_Nib_Name = "Login"
    }
    
    enum Home {
        static let Home_Storyboard_Name = "HomeStoryboard"
        static let Home_View_Name = "HomeViewController"
        static let Category_View_Name = "CategoryViewController"
        static let Product_View_Name = "ProductViewController"
    }
    
    enum Shopify {
        static let Shopify_API_Key = "236f00d0acd3538f6713fd3a323150b6"
        static let Shopify_API_Secret = "f7e30cfe8bb4caedc97901323c1a2d67"
        static let Shopify_Shop_Name = "mad44-sv-iost1"
        static let Access_Token = "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"
        static let Base_URL = "https://mad44-sv-iost1.myshopify.com/admin/api/2023-01/"
    }
    
    enum HTTPMethod {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    enum CategoryID {
        static let ALL = 0
        static let MEN = 287822315567
        static let WOMEN = 287822348335
        static let KID = 287822381103
        static let SALE = 287822413871
    }
    
    //MARK: Add any Const ants u need in a staruct pleas
}
