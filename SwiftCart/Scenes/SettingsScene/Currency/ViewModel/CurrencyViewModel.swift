//
//  CurrencyViewModel.swift
//  SwiftCart
//
//  Created by Israa on 20/06/2024.
//

import Foundation

class CurrencyViewModel {
    
    func getTheSelectedCurrency() -> String {
        return UserDefaultsHelper.shared.getCurrencyType() ?? "EGP"
    }
    
    func fetchCurrencyDataAndStore(currencyType: String, completion: @escaping (Bool, String?) -> Void) {
        CurrencyManager.instance.getData { (result: Currency?, error) in
            if let result = result, let currencyData = result.data[currencyType] {
                UserDefaultsHelper.shared.saveCurrency(currencyType: currencyType, value: currencyData.value)
                completion(true, nil)
            } else {
                let errorMessage = error ?? "Unknown error"
                completion(false, errorMessage)
            }
        }
    }
}
