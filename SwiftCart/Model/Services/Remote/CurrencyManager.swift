//
//  CurrencyManager.swift
//  SwiftCart
//
//  Created by Israa on 20/06/2024.
//

import Foundation
import Alamofire

class CurrencyManager {
    static let instance = CurrencyManager()
    
    func buildCurrencyAPIURL() -> String {
        let baseURL = K.Currency.baseURL.rawValue
        let apiKey = K.Currency.ApiKey.rawValue
        let baseCurrency = K.Currency.USD.rawValue
        let currencies = [K.Currency.egp.rawValue, K.Currency.SAR.rawValue].joined(separator: "&currencies[]=")
        
        let url = "\(baseURL)?apikey=\(apiKey)&base_currency=\(baseCurrency)&currencies[]=\(currencies)"
        return url
    }
    
    func getData(complitionHandler: @escaping (Currency?, String?) -> Void) {
        guard let url = URL(string: self.buildCurrencyAPIURL()) else {
            complitionHandler(nil, "")
            return
        }
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: Currency.self) { response in
                switch response.result {
                case .success(let value):
                    complitionHandler(value, "Success")
                case .failure(let error):
                    print(error)
                    complitionHandler(nil, "Failed")
                }
            }
    }
    
    func getCurrencyType() -> String {
        if let currencyType = UserDefaultsHelper.shared.getCurrencyType() {
            return currencyType
        } else {
            return K.Currency.egp.rawValue
        }
    }
}
