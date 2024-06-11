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

protocol Networking{
    func getApiData(url: String) -> Observable<Data>
    
}

class NetworkManager : Networking {
    static let shared = NetworkManager()
    
    private init() {}
    
    func getApiData(url: String) -> Observable<Data> {
        print("NetworkManager: Preparing to request data from URL: \(url)")
        
        return RxAlamofire.data(.get, url)
            .flatMap { data -> Observable<Data> in
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("NetworkManager: Response Data: \(jsonString)")
                } else {
                    print("NetworkManager: Response Data: unable to convert to string")
                }
                return Observable.just(data)
            }
    }
    
    
    private func createRequestDetails(url : String ,endpoint: String, headers: HTTPHeaders?) -> (String, HTTPHeaders) {
        let url = "\(K.Shopify.Base_URL)\(endpoint)"
        var combinedHeaders = headers ?? HTTPHeaders()
        combinedHeaders.add(name: "X-Shopify-Access-Token", value: K.Shopify.Access_Token)
        combinedHeaders.add(name: "Content", value: "application/json")
        return (url, combinedHeaders)
    }

    func get<T: Decodable>(url: String = K.Shopify.Base_URL, endpoint: String, parameters: [String: Any]? = nil, headers: HTTPHeaders? = nil) -> Observable<T> {
        let (url, combinedHeaders) = createRequestDetails(url: url, endpoint: endpoint, headers: headers)

        return RxAlamofire
            .requestData(.get, url, parameters: parameters, encoding: URLEncoding.default, headers: combinedHeaders)
            .flatMap { response, data -> Observable<T> in
                if let decodedObject: T = Utils.convertTo(from: data) {
                    return Observable.just(decodedObject)
                } else {
                    return Observable.error(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Decoding error"]))
                }
            }
    }

}
