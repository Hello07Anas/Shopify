//
//  FavCRUD.swift
//  SwiftCart
//
//  Created by Anas Salah on 17/06/2024.
//

import Foundation
import Alamofire

struct FavCRUD {
    let baseUrl = K.Shopify.Base_URL + "draft_orders"
    let accessToken = K.Shopify.Access_Token
    
    struct DraftOrderResponse: Codable {
        let draft_order: DraftOrder
    }

    struct DraftOrder: Codable {
        var line_items: [LineItem]?
    }

    struct LineItem: Codable {
        let id: Int?
        let quantity: Int
        let price: String
        let title: String
        let properties: [[String: String]]
    }

    struct DraftOrderUpdateRequest: Codable {
        let draft_order: DraftOrder
    }

    func saveItem(favId: Int, itemId: Int, itemImg: String, itemName: String, itemPrice: Double, completion: @escaping (Bool) -> Void) {
        let lineItem = LineItem(id: nil, quantity: 1, price: String(format: "%.2f", itemPrice), title: itemName, properties: [
            ["name": "image", "value": itemImg],
            ["name": "itemId", "value": String(itemId)]
        ])

        getDraftOrder(favId: favId) { draftOrder in
            var updatedDraftOrder = draftOrder ?? DraftOrder(line_items: [])
            updatedDraftOrder.line_items?.append(lineItem)

            let updateRequest = DraftOrderUpdateRequest(draft_order: updatedDraftOrder)

            self.updateDraftOrder(favId: favId, updateRequest: updateRequest) { success in
                completion(success)
            }
        }
    }

    func deleteItem(favId: Int, itemId: Int, completion: @escaping (Bool) -> Void) {
        getDraftOrder(favId: favId) { draftOrder in
            guard var updatedDraftOrder = draftOrder else {
                print("No draft order found")
                completion(false)
                return
            }

            if let index = updatedDraftOrder.line_items?.firstIndex(where: {
                $0.properties.contains(where: { $0["name"] == "itemId" && $0["value"] == String(itemId) })
            }) {
                updatedDraftOrder.line_items?.remove(at: index)
            } else {
                print("Item with id \(itemId) not found in line_items")
                completion(false)
                return
            }

            let updateRequest = DraftOrderUpdateRequest(draft_order: updatedDraftOrder)
            self.updateDraftOrder(favId: favId, updateRequest: updateRequest) { success in
                completion(success)
            }
        }
    }


    func readItems(favId: Int, completion: @escaping ([LineItem]) -> Void) {
        getDraftOrder(favId: favId) { draftOrder in
            guard let draftOrder = draftOrder else {
                completion([])
                return
            }
            
            guard let lineItems = draftOrder.line_items else {
                completion([])
                return
            }
            
            let items = lineItems.dropFirst().map { item in
                var newItem = item
                if let itemIdProperty = item.properties.first(where: { $0["name"] == "itemId" }),
                   let itemId = itemIdProperty["value"],
                   let id = Int(itemId) {
                    newItem = LineItem(id: id, quantity: item.quantity, price: item.price, title: item.title, properties: item.properties)
                }
                return newItem
            }
            
            completion(items)
        }
    }



    func getDraftOrder(favId: Int, completion: ((DraftOrder?) -> Void)? = nil) {
        let endpoint = "/\(favId).json"
        AF.request(baseUrl + endpoint, method: .get, headers: ["X-Shopify-Access-Token": accessToken])
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("JSON Response:", json)
                        }

                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let draftOrderResponse = try decoder.decode(DraftOrderResponse.self, from: data)
                        completion?(draftOrderResponse.draft_order)
                    } catch {
                        print("Failed to decode draft order:", error)
                        completion?(nil)
                    }
                case .failure(let error):
                    print("Failed to fetch draft order:", error)
                    completion?(nil)
                }
            }
    }
    
    func updateDraftOrder(favId: Int, updateRequest: DraftOrderUpdateRequest, completion: ((Bool) -> Void)? = nil) {
        let endpoint = "/\(favId).json"
        AF.request(baseUrl + endpoint, method: .put, parameters: updateRequest, encoder: JSONParameterEncoder.default, headers: ["X-Shopify-Access-Token": accessToken])
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let updatedDraftOrder = try decoder.decode(DraftOrderResponse.self, from: data)
                        print("Successfully updated draft order:", updatedDraftOrder.draft_order)
                        completion?(true)
                    } catch {
                        print("Failed to decode updated draft order:", error)
                        completion?(false)
                    }
                case .failure(let error):
                    print("Failed to update draft order:", error)
                    completion?(false)
                }
            }
    }

}
