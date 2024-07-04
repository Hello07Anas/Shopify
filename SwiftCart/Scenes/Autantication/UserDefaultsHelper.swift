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
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String, CaseIterable {
        case userEmail, userName, userUID, shopifyCustomerID, cartID, favID
        case selectedCurrencyType, defaultFirstName, defaultLastName, defaultAddress, defaultCity, defaultPhone
    }
    
    // MARK: - User Data Management
    
    func saveUserData(email: String, name: String, uid: String, shopifyCustomerID: String, cartID: String, favID: String) {
        userDefaults.set(email, forKey: Keys.userEmail.rawValue)
        userDefaults.set(name, forKey: Keys.userName.rawValue)
        userDefaults.set(uid, forKey: Keys.userUID.rawValue)
        userDefaults.set(shopifyCustomerID, forKey: Keys.shopifyCustomerID.rawValue)
        userDefaults.set(cartID, forKey: Keys.cartID.rawValue)
        userDefaults.set(favID, forKey: Keys.favID.rawValue)
    }
    
    func getUserData() -> (email: String?, name: String?, uid: String?, shopifyCustomerID: String?, cartID: String?, favID: String?) {
        let userEmail = userDefaults.string(forKey: Keys.userEmail.rawValue)
        let userName = userDefaults.string(forKey: Keys.userName.rawValue)
        let userUID = userDefaults.string(forKey: Keys.userUID.rawValue)
        let shopifyCustomerID = userDefaults.string(forKey: Keys.shopifyCustomerID.rawValue)
        let cartID = userDefaults.string(forKey: Keys.cartID.rawValue)
        let favID = userDefaults.string(forKey: Keys.favID.rawValue)
        
        return (userEmail, userName, userUID, shopifyCustomerID, cartID, favID)
    }
    
    func clearUserData() {
        Keys.allCases.forEach { key in
            userDefaults.removeObject(forKey: key.rawValue)
        }
    }
    
    func printAllUserDefaults() {
        let dictionary = userDefaults.dictionaryRepresentation()
        print("====UserDefaults Contents====")
        for (key, value) in dictionary {
            print("\(key) = \(value)")
        }
        print("====End of UserDefaults Contents====")
    }
    
    func printUserDefaults() -> Customer {
        let userEmail = userDefaults.string(forKey: Keys.userEmail.rawValue) ?? "No Data"
        let userName = userDefaults.string(forKey: Keys.userName.rawValue) ?? "No Data"
        let userUID = userDefaults.string(forKey: Keys.userUID.rawValue) ?? "No Data"
        let shopifyCustomerID = userDefaults.string(forKey: Keys.shopifyCustomerID.rawValue) ?? "No Data"
        
        return Customer(id: Int(shopifyCustomerID) ?? 0, email: userEmail, firstName: userName, lastName: "")
    }
    
    // MARK: - Currency Management
    
    func saveCurrency(currencyType: String, value: Double) {
        userDefaults.set(value, forKey: currencyType.uppercased())
    }
    
    func getCurrencyValue(for currencyType: String) -> Double? {
        let value = userDefaults.double(forKey: currencyType.uppercased())
        return value != 0 ? value : 1.0
    }
    
    func getCurrencyType() -> String? {
        return userDefaults.string(forKey: Keys.selectedCurrencyType.rawValue)
    }
    
    func saveCurrencyType(currencyType: String) {
        userDefaults.set(currencyType.uppercased(), forKey: Keys.selectedCurrencyType.rawValue)
    }
    
    func deleteCurrency(currencyType: String) {
        userDefaults.removeObject(forKey: currencyType.uppercased())
    }
    
    // MARK: - Default Address Management
    
    func saveDefaultAddress(firstName: String, lastName: String, address: String, city: String, phone: String) {
        userDefaults.set(firstName, forKey: Keys.defaultFirstName.rawValue)
        userDefaults.set(lastName, forKey: Keys.defaultLastName.rawValue)
        userDefaults.set(address, forKey: Keys.defaultAddress.rawValue)
        userDefaults.set(city, forKey: Keys.defaultCity.rawValue)
        userDefaults.set(phone, forKey: Keys.defaultPhone.rawValue)
    }
    
    func getDefaultAddress() -> (firstName: String?, lastName: String?, address: String?, city: String?, phone: String?) {
        let firstName = userDefaults.string(forKey: Keys.defaultFirstName.rawValue)
        let lastName = userDefaults.string(forKey: Keys.defaultLastName.rawValue)
        let address = userDefaults.string(forKey: Keys.defaultAddress.rawValue)
        let city = userDefaults.string(forKey: Keys.defaultCity.rawValue)
        let phone = userDefaults.string(forKey: Keys.defaultPhone.rawValue)
        
        return (firstName, lastName, address, city, phone)
    }
    
    func deleteDefaultAddress() {
        userDefaults.removeObject(forKey: Keys.defaultFirstName.rawValue)
        userDefaults.removeObject(forKey: Keys.defaultLastName.rawValue)
        userDefaults.removeObject(forKey: Keys.defaultAddress.rawValue)
        userDefaults.removeObject(forKey: Keys.defaultCity.rawValue)
        userDefaults.removeObject(forKey: Keys.defaultPhone.rawValue)
    }
}
