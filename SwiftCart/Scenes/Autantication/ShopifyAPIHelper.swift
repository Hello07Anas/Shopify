//
//  ShopifyAPIHelper.swift
//  SwiftCart
//
//  Created by Anas Salah on 09/06/2024.
//

import Foundation

class ShopifyAPIHelper {
    
    static let shared = ShopifyAPIHelper()
    
    private init() {}
    
    private func createRequest(withPath path: String, method: String, body: [String: Any]? = nil) -> URLRequest {
        let url = URL(string: K.Shopify.Base_URL + path)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(K.Shopify.Access_Token, forHTTPHeaderField: "X-Shopify-Access-Token") // Correct header
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        print("Request URL: \(url)")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = body {
            print("Request Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "No Body")")
        }
        
        return request
    }
    
    func createCustomer(email: String, firstName: String, lastName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let path = "customers.json"
        let method = K.HTTPMethod.POST
        
        let customerData: [String: Any] = [
            "customer": [
                "email": email,
                "first_name": firstName,
                "last_name": lastName
            ]
        ]
        
        let request = createRequest(withPath: path, method: method, body: customerData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating customer: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "ShopifyAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response received"])
                print("No HTTP response received")
                completion(.failure(error))
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            if let data = data {
                print("Response Data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
            
            if (200..<300).contains(httpResponse.statusCode), let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let customerDict = json["customer"] as? [String: Any],
                       let customerId = customerDict["id"] as? Int {
                        print("Customer created with ID: \(customerId)")
                        completion(.success("Customer created with ID: \(customerId)"))
                    } else {
                        print("Invalid JSON structure")
                        let error = NSError(domain: "ShopifyAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                        completion(.failure(error))
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                let errorDescription = "Server returned status code \(httpResponse.statusCode)"
                print(errorDescription)
                let error = NSError(domain: "ShopifyAPI", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                completion(.failure(error))
            }
        }.resume()
    }
}
