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

    func saveItem(favId: Int, itemId: Int, itemImg: String, itemName: String, itemPrice: Double) {
        let lineItem = LineItem(id: nil, quantity: 1, price: String(format: "%.2f", itemPrice), title: itemName, properties: [["name": "image", "value": itemImg]])

        getDraftOrder(favId: favId) { draftOrder in
            var updatedDraftOrder = draftOrder ?? DraftOrder(line_items: [])
            updatedDraftOrder.line_items?.append(lineItem)

            let updateRequest = DraftOrderUpdateRequest(draft_order: updatedDraftOrder)

            self.updateDraftOrder(favId: favId, updateRequest: updateRequest)
        }
    }

    func deleteItem(favId: Int, itemId: Int) {
        getDraftOrder(favId: favId) { draftOrder in
            guard var updatedDraftOrder = draftOrder else {
                print("No draft order found")
                return
            }
            
            //print("Before deletion: \(updatedDraftOrder.line_items!)")
            updatedDraftOrder.line_items?.removeAll { $0.id == itemId }
            //print("After deletion: \(updatedDraftOrder.line_items!)")

            let updateRequest = DraftOrderUpdateRequest(draft_order: updatedDraftOrder)
            self.updateDraftOrder(favId: favId, updateRequest: updateRequest)
        }
    }


    func readItems(favId: Int, completion: @escaping ([LineItem]) -> Void) {
        getDraftOrder(favId: favId) { draftOrder in
            completion(draftOrder?.line_items ?? [])
        }
    }

    private func getDraftOrder(favId: Int, completion: @escaping (DraftOrder?) -> Void) {
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
                        completion(draftOrderResponse.draft_order)
                    } catch {
                        print("Failed to decode draft order:", error)
                        completion(nil)
                    }
                case .failure(let error):
                    print("Failed to fetch draft order:", error)
                    completion(nil)
                }
            }
    }
    private func updateDraftOrder(favId: Int, updateRequest: DraftOrderUpdateRequest) {
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
                    } catch {
                        print("Failed to decode updated draft order:", error)
                    }
                case .failure(let error):
                    print("Failed to update draft order:", error)
                }
            }
    }
}
