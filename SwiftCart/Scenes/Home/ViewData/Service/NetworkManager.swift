//
//  NetworkManager.swift
//  SwiftCart
//
//  Created by Elham on 02/06/2024.
//



import Foundation
import Alamofire
import RxSwift
import RxAlamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func getApiData<T: Decodable>(url: String) -> Observable<T> {
        print("NetworkManager: Preparing to request data from URL: \(url)")
        
        return RxAlamofire.data(.get, url)
            .flatMap { data -> Observable<T> in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("NetworkManager: Response Data: \(jsonString)")
                } else {
                    print("NetworkManager: Response Data: unable to convert to string")
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    print("NetworkManager: Decoding successful")
                    return Observable.just(decodedData)
                } catch let decodingError {
                   
                    print("NetworkManager: Decoding error: \(decodingError)")
                    throw decodingError
                }
            }
    }
}

