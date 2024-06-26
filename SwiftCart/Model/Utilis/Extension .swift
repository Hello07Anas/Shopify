//
//  Extension .swift
//  SwiftCart
//
//  Created by Israa on 16/06/2024.
//

import Foundation
import UIKit

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension String {
    
    private func getCurrencyValue(from userDefaults: UserDefaults, for currencyType: String) -> Double? {
        let value = userDefaults.double(forKey: currencyType)
        print("Retrieved currency value: \(value) for type: \(currencyType)") // Debugging print
        return value != 0 ? value/2 : 1.0
    }
    
    private func getCurrencySymbol(for currencyType: String) -> String {
        switch currencyType.uppercased() {
        case "USD":
            return "$"
        case "EGP":
            return "EGP"
        case "SAR":
            return "SAR"
        default:
            return ""
        }
    }
    
    func formatAsCurrency() -> String {
        let userDefaults = UserDefaults.standard
        let currencyType = CurrencyManager.instance.getCurrencyType()
        
        guard let value = Double(self) else {
            print("Failed to convert string to double: \(self)") // Debugging print
            return self
        }
        
        guard let currencyValue = getCurrencyValue(from: userDefaults, for: currencyType.uppercased()) else {
            print("Failed to retrieve currency value for type: \(currencyType)") // Debugging print
            return self
        }
        
        let convertedValue = value * currencyValue
        let currencySymbol = getCurrencySymbol(for: currencyType)
        
        print("Converted value: \(convertedValue) with symbol: \(currencySymbol)") // Debugging print
        
        return "\(String(format: "%.2f", convertedValue)) \(currencySymbol)"
    }
}
