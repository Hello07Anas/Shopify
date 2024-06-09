//
//  UserDefaultsHelper.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import Foundation

struct UserDefaultsHelper {
    
    static let shared = UserDefaultsHelper()
    
    private init() {}
    
    func saveUserData(email: String, name: String, uid: String, shopifyCustomerID: String) {
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(uid, forKey: "userUID")
        UserDefaults.standard.set(shopifyCustomerID, forKey: "shopifyCustomerID")
        
        UserDefaults.standard.synchronize()
    }
    
    func getUserData() -> (email: String?, name: String?, uid: String?, shopifyCustomerID: String?) {
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")
        let userName = UserDefaults.standard.string(forKey: "userName")
        let userUID = UserDefaults.standard.string(forKey: "userUID")
        let shopifyCustomerID = UserDefaults.standard.string(forKey: "shopifyCustomerID")
        
        return (userEmail, userName, userUID, shopifyCustomerID)
    }
    
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userUID")
        UserDefaults.standard.removeObject(forKey: "shopifyCustomerID")
        
        UserDefaults.standard.synchronize()
    }
    
    func printUserDefaults() {
        let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "N/A"
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "N/A"
        let userUID = UserDefaults.standard.string(forKey: "userUID") ?? "N/A"
        let shopifyCustomerID = UserDefaults.standard.string(forKey: "shopifyCustomerID") ?? "N/A"
        
        print("UserDefaults - Email: \(userEmail), Name: \(userName), UID: \(userUID), ShopifyCustomerID: \(shopifyCustomerID)")
    }
}
