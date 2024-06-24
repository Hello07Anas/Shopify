//
//  SwiftCartTests.swift
//  SwiftCartTests
//
//  Created by Anas Salah on 22/06/2024.
//

import XCTest
import RxSwift
import RxAlamofire
@testable import SwiftCart

final class SwiftCartTests: XCTestCase {
    
    var service: NetworkManager!
    var disposeBag: DisposeBag!
    var mockSession: URLSessionMock!
    
    override func setUpWithError() throws {
        super.setUp()
        service = NetworkManager.shared
        disposeBag = DisposeBag()
        mockSession = URLSessionMock()
    }
    
    override func tearDownWithError() throws {
        service = nil
        disposeBag = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testMakeAPICall_Success() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")
        let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/products.json"
        
        let jsonData = """
        {
            "products": [
                {
                    "id": 7680312049711,
                    "title": "ASICS TIGER | GEL-LYTE V '30 YEARS OF GEL' PACK",
                    "body_html": "The iconic ASICS Tiger GEL-Lyte III was originally released in 1990. Having over two decades of performance heritage, it offers fine design detailing and a padded split tongue to eliminate tongue movement, built on a sleek silhouette. It comes as no surprise the Gel-Lyte III is a fast growing popular choice for sneaker enthusiasts all over the world.",
                    "vendor": "ASICS TIGER",
                    "product_type": "SHOES",
                    "created_at": "2024-05-27T08:16:54-04:00",
                    "handle": "asics-tiger-gel-lyte-v-30-years-of-gel-pack",
                    "updated_at": "2024-05-27T08:19:11-04:00",
                    "published_at": "2024-05-27T08:16:53-04:00",
                    "template_suffix": null,
                    "published_scope": "global",
                    "tags": "asics-tiger, autumn, egnition-sample-data, men, spring",
                    "status": "active",
                    "admin_graphql_api_id": "gid://shopify/Product/7680312049711",
                    "variants": [
                        {
                            "id": 42871005511727,
                            "product_id": 7680312049711,
                            "title": "4 / black",
                            "price": "220.00",
                            "sku": "AsTi-01-black-4",
                            "position": 1,
                            "inventory_policy": "deny",
                            "compare_at_price": null,
                            "fulfillment_service": "manual",
                            "inventory_management": "shopify",
                            "option1": "4",
                            "option2": "black",
                            "option3": null,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:19:10-04:00",
                            "taxable": true,
                            "barcode": null,
                            "grams": 0,
                            "weight": 0.0,
                            "weight_unit": "kg",
                            "inventory_item_id": 44966352060463,
                            "inventory_quantity": 1,
                            "old_inventory_quantity": 1,
                            "requires_shipping": true,
                            "admin_graphql_api_id": "gid://shopify/ProductVariant/42871005511727",
                            "image_id": null
                        },
                        {
                            "id": 42871005544495,
                            "product_id": 7680312049711,
                            "title": "8 / black",
                            "price": "220.00",
                            "sku": "AsTi-01-black-8",
                            "position": 2,
                            "inventory_policy": "deny",
                            "compare_at_price": null,
                            "fulfillment_service": "manual",
                            "inventory_management": "shopify",
                            "option1": "8",
                            "option2": "black",
                            "option3": null,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:19:11-04:00",
                            "taxable": true,
                            "barcode": null,
                            "grams": 0,
                            "weight": 0.0,
                            "weight_unit": "kg",
                            "inventory_item_id": 44966352093231,
                            "inventory_quantity": 20,
                            "old_inventory_quantity": 20,
                            "requires_shipping": true,
                            "admin_graphql_api_id": "gid://shopify/ProductVariant/42871005544495",
                            "image_id": null
                        },
                        {
                            "id": 42871005577263,
                            "product_id": 7680312049711,
                            "title": "14 / black",
                            "price": "220.00",
                            "sku": "AsTi-01-black-14",
                            "position": 3,
                            "inventory_policy": "deny",
                            "compare_at_price": null,
                            "fulfillment_service": "manual",
                            "inventory_management": "shopify",
                            "option1": "14",
                            "option2": "black",
                            "option3": null,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:19:10-04:00",
                            "taxable": true,
                            "barcode": null,
                            "grams": 0,
                            "weight": 0.0,
                            "weight_unit": "kg",
                            "inventory_item_id": 44966352125999,
                            "inventory_quantity": 2,
                            "old_inventory_quantity": 2,
                            "requires_shipping": true,
                            "admin_graphql_api_id": "gid://shopify/ProductVariant/42871005577263",
                            "image_id": null
                        }
                    ],
                    "options": [
                        {
                            "id": 9744868409391,
                            "product_id": 7680312049711,
                            "name": "Size",
                            "position": 1,
                            "values": [
                                "4",
                                "8",
                                "14"
                            ]
                        },
                        {
                            "id": 9744868442159,
                            "product_id": 7680312049711,
                            "name": "Color",
                            "position": 2,
                            "values": [
                                "black"
                            ]
                        }
                    ],
                    "images": [
                        {
                            "id": 33973337784367,
                            "alt": null,
                            "position": 1,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337784367",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/343bfbfc1a10a39a528a3d34367669c2.jpg?v=1716812214",
                            "variant_ids": []
                        },
                        {
                            "id": 33973337817135,
                            "alt": null,
                            "position": 2,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337817135",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/548e71e82d4b2d3bdd2b739b4872edc9.jpg?v=1716812214",
                            "variant_ids": []
                        },
                        {
                            "id": 33973337849903,
                            "alt": null,
                            "position": 3,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337849903",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/92b18b29e25d47479716de9da45c6f11.jpg?v=1716812214",
                            "variant_ids": []
                        },
                        {
                            "id": 33973337882671,
                            "alt": null,
                            "position": 4,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337882671",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/849cb34b82473241efdfcf60f9106452.jpg?v=1716812214",
                            "variant_ids": []
                        },
                        {
                            "id": 33973337915439,
                            "alt": null,
                            "position": 5,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337915439",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/262cb366636c10febf8b843a1d0853c5.jpg?v=1716812214",
                            "variant_ids": []
                        }
                    ],
                    "image": {
                        "id": 33973337784367,
                        "alt": null,
                        "position": 1,
                        "product_id": 7680312049711,
                        "created_at": "2024-05-27T08:16:54-04:00",
                        "updated_at": "2024-05-27T08:16:54-04:00",
                        "admin_graphql_api_id": "gid://shopify/ProductImage/33973337784367",
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/343bfbfc1a10a39a528a3d34367669c2.jpg?v=1716812214",
                        "variant_ids": []
                    }
                }
           ]
        }
        """.data(using: .utf8)!
        
        var capturedData: Data?
        var capturedURL: String?
        
        // Stub the network request
        mockSession.data = jsonData
        let mockSession = URLSessionMock()
        
        // Act
        service.getApiData(url: url)
            .subscribe(onNext: { data in
                capturedData = data
                capturedURL = url
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Expected successful response, but got error: \(error)")
            })
            .disposed(by: disposeBag)
        
        // Assert
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error, "Timeout")
            XCTAssertEqual(capturedURL, url)
            XCTAssertNotNil(capturedData)
            
            if let capturedData = capturedData {
                let productsResponse: ProductResponse? = Utils.convertTo(from: capturedData)
                XCTAssertEqual(productsResponse?.products?.first?.id, 7680312049711)
            }
        }
    }
    
    func testGetAPIData_Success() throws {
        // Arrange
        let endpoint = "products.json"
        let expectedProductId = 7680312049711
        
        // Sample JSON data representing the API response
        let jsonData = """
        {
            "products": [
                {
                    "id": 7680312049711,
                    "title": "ASICS TIGER | GEL-LYTE V '30 YEARS OF GEL' PACK",
                    "body_html": "The iconic ASICS Tiger GEL-Lyte III was originally released in 1990. Having over two decades of performance heritage, it offers fine design detailing and a padded split tongue to eliminate tongue movement, built on a sleek silhouette. It comes as no surprise the Gel-Lyte III is a fast growing popular choice for sneaker enthusiasts all over the world.",
                    "vendor": "ASICS TIGER",
                    "product_type": "SHOES",
                    "created_at": "2024-05-27T08:16:54-04:00",
                    "handle": "asics-tiger-gel-lyte-v-30-years-of-gel-pack",
                    "updated_at": "2024-05-27T08:19:11-04:00",
                    "published_at": "2024-05-27T08:16:53-04:00",
                    "template_suffix": null,
                    "published_scope": "global",
                    "tags": "asics-tiger, autumn, egnition-sample-data, men, spring",
                    "status": "active",
                    "admin_graphql_api_id": "gid://shopify/Product/7680312049711",
                    "variants": [
                        {
                            "id": 42871005511727,
                            "product_id": 7680312049711,
                            "title": "4 / black",
                            "price": "220.00",
                            "sku": "AsTi-01-black-4",
                            "position": 1,
                            "inventory_policy": "deny",
                            "compare_at_price": null,
                            "fulfillment_service": "manual",
                            "inventory_management": "shopify",
                            "option1": "4",
                            "option2": "black",
                            "option3": null,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:19:10-04:00",
                            "taxable": true,
                            "barcode": null,
                            "grams": 0,
                            "weight": 0.0,
                            "weight_unit": "kg",
                            "inventory_item_id": 44966352060463,
                            "inventory_quantity": 1,
                            "old_inventory_quantity": 1,
                            "requires_shipping": true,
                            "admin_graphql_api_id": "gid://shopify/ProductVariant/42871005511727",
                            "image_id": null
                        },
                        {
                            "id": 42871005544495,
                            "product_id": 7680312049711,
                            "title": "8 / black",
                            "price": "220.00",
                            "sku": "AsTi-01-black-8",
                            "position": 2,
                            "inventory_policy": "deny",
                            "compare_at_price": null,
                            "fulfillment_service": "manual",
                            "inventory_management": "shopify",
                            "option1": "8",
                            "option2": "black",
                            "option3": null,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:19:11-04:00",
                            "taxable": true,
                            "barcode": null,
                            "grams": 0,
                            "weight": 0.0,
                            "weight_unit": "kg",
                            "inventory_item_id": 44966352093231,
                            "inventory_quantity": 20,
                            "old_inventory_quantity": 20,
                            "requires_shipping": true,
                            "admin_graphql_api_id": "gid://shopify/ProductVariant/42871005544495",
                            "image_id": null
                        },
                        {
                            "id": 42871005577263,
                            "product_id": 7680312049711,
                            "title": "14 / black",
                            "price": "220.00",
                            "sku": "AsTi-01-black-14",
                            "position": 3,
                            "inventory_policy": "deny",
                            "compare_at_price": null,
                            "fulfillment_service": "manual",
                            "inventory_management": "shopify",
                            "option1": "14",
                            "option2": "black",
                            "option3": null,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:19:10-04:00",
                            "taxable": true,
                            "barcode": null,
                            "grams": 0,
                            "weight": 0.0,
                            "weight_unit": "kg",
                            "inventory_item_id": 44966352125999,
                            "inventory_quantity": 2,
                            "old_inventory_quantity": 2,
                            "requires_shipping": true,
                            "admin_graphql_api_id": "gid://shopify/ProductVariant/42871005577263",
                            "image_id": null
                        }
                    ],
                    "options": [
                        {
                            "id": 9744868409391,
                            "product_id": 7680312049711,
                            "name": "Size",
                            "position": 1,
                            "values": [
                                "4",
                                "8",
                                "14"
                            ]
                        },
                        {
                            "id": 9744868442159,
                            "product_id": 7680312049711,
                            "name": "Color",
                            "position": 2,
                            "values": [
                                "black"
                            ]
                        }
                    ],
                    "images": [
                        {
                            "id": 33973337784367,
                            "alt": null,
                            "position": 1,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337784367",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/343bfbfc1a10a39a528a3d34367669c2.jpg?v=1716812214",
                            "variant_ids": []
                        },
                        {
                            "id": 33973337817135,
                            "alt": null,
                            "position": 2,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337817135",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/548e71e82d4b2d3bdd2b739b4872edc9.jpg?v=1716812214",
                            "variant_ids": []
                        },
                        {
                            "id": 33973337849903,
                            "alt": null,
                            "position": 3,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337849903",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/92b18b29e25d47479716de9da45c6f11.jpg?v=1716812214",
                            "variant_ids": []
                        },
                        {
                            "id": 33973337882671,
                            "alt": null,
                            "position": 4,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337882671",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/849cb34b82473241efdfcf60f9106452.jpg?v=1716812214",
                            "variant_ids": []
                        },
                        {
                            "id": 33973337915439,
                            "alt": null,
                            "position": 5,
                            "product_id": 7680312049711,
                            "created_at": "2024-05-27T08:16:54-04:00",
                            "updated_at": "2024-05-27T08:16:54-04:00",
                            "admin_graphql_api_id": "gid://shopify/ProductImage/33973337915439",
                            "width": 635,
                            "height": 560,
                            "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/262cb366636c10febf8b843a1d0853c5.jpg?v=1716812214",
                            "variant_ids": []
                        }
                    ],
                    "image": {
                        "id": 33973337784367,
                        "alt": null,
                        "position": 1,
                        "product_id": 7680312049711,
                        "created_at": "2024-05-27T08:16:54-04:00",
                        "updated_at": "2024-05-27T08:16:54-04:00",
                        "admin_graphql_api_id": "gid://shopify/ProductImage/33973337784367",
                        "width": 635,
                        "height": 560,
                        "src": "https://cdn.shopify.com/s/files/1/0624/0239/6207/files/343bfbfc1a10a39a528a3d34367669c2.jpg?v=1716812214",
                        "variant_ids": []
                    }
                }
           ]
        }
        """.data(using: .utf8)!
        
        // Stub the network request
        mockSession.data = jsonData
        
        // Set up the expectation
        let expectation = XCTestExpectation(description: "API call succeeds")
        
        // Act
        var capturedProductId: Int?
        var apiError: Error?
        
        let observable: Observable<ProductResponse> = service.get(endpoint: endpoint)
        
        // Assert
        _ = observable
            .subscribe(onNext: { productsResponse in
                capturedProductId = productsResponse.products?.first?.id
                expectation.fulfill()
            }, onError: { error in
                apiError = error
                XCTFail("Expected successful response, but got error: \(error)")
            })
            .disposed(by: disposeBag)
        
        // Wait for the expectation to fulfill
        wait(for: [expectation], timeout: 10)
        
        // Assert the captured product ID
        XCTAssertNil(apiError, "API call failed with error: \(apiError!)")
        XCTAssertEqual(capturedProductId, expectedProductId, "Expected product ID \(expectedProductId), but got \(capturedProductId ?? -1)")
    }
    
    
    
    func testCannotDeleteDefaultAddress() throws {
        let address = Address(
            id: 8249939197999,
            customerID: 6930899632175,
            firstName: "Israa",
            lastName: "Mhmmd",
            address1: "13-street",
            city: "Al-Gharbia",
            country: "Egypt",
            phone: "015515529391",
            isDefault: true
        )
        
        let customerId = K.Shopify.userID
        let endpoint = K.endPoints.putOrDeleteAddress.rawValue
            .replacingOccurrences(of: "{customer_id}", with: customerId)
            .replacingOccurrences(of: "{address_id}", with: "8249939197999")
    
        // Create an expectation
        let expectation = XCTestExpectation(description: "API call succeeds")
        
        // Act
        let observable: Observable<Int> = service.delete(endpoint: endpoint)
        
        // Assert
        _ = observable
            .subscribe(onNext: { statusCode in
                XCTAssertEqual(statusCode, 404)
                expectation.fulfill()
            }, onError: { error in
                XCTAssertEqual(error.localizedDescription, "Cannot delete the customer’s default address")
            })
            .disposed(by: disposeBag)
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5)
    }
    
    func testPostAPI_Success()  {
     
            let expectation = self.expectation(description: "API call succeeds")
            
            let endpoint = "orders.json"
            let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/"

            let address = Address(
                id: nil,
                customerID: nil,
                firstName: "John",
                lastName: "Doe",
                address1: "123 Main St",
                city: "Cairo",
                country: "Egypt",
                phone: "011123456789",
                isDefault: true
            )

            let billingAddress = Address(
                id: nil,
                customerID: nil,
                firstName: "John",
                lastName: "Doe",
                address1: "123 Main St",
                city: "Cairo",
                country: "EG",
                phone: "011123456789",
                isDefault: true
            )

            let testOrder = Order(
                id: 1073460025,
                orderNumber: "#122",
                productNumber: 2,
                address: address,
                date: "2024-05-14T21:19:37-04:00",
                currency: .eur,
                email: UserDefaults.standard.string(forKey: "userEmail") ?? "",
                totalPrice: "290.00",
                items: [
                    ItemProductOrder(id: 1071823276, image: "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402", price: "80", quantity: 3, title: "Big Brown Bear Boots"),
                    ItemProductOrder(id: 1081823276, image: "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402", price: "50", quantity: 1, title: "Brown Bear Boots")
                ],
                userID: Int(K.Shopify.userID),
                billingAddress: billingAddress,
                customer: UserDefaultsHelper.shared.printUserDefaults()
            )

            // Encode testOrder into JSON
            do {
                let jsonData = try JSONEncoder().encode(testOrder)
                
                guard let orderDict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] else {
                    XCTFail("Failed to convert order data to dictionary")
                    return
                }
                
                NetworkManager.shared.postOrder(url: url, endpoint: endpoint, body: ["order": orderDict])
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (success, message, responseOrder) in
                        // Assert
                        XCTAssertTrue(success, "Expected successful response, but got: \(message ?? "")")
                        XCTAssertEqual(responseOrder?.order.address?.city, testOrder.address?.city)
                        XCTAssertEqual(responseOrder?.order.totalPrice, testOrder.totalPrice)
                        XCTAssertEqual(responseOrder?.order.address?.phone, testOrder.address?.phone)
                        expectation.fulfill()
                    }, onError: { error in
                        XCTFail("Expected successful response, but got error: \(error)")
                    })
                    .disposed(by: disposeBag)

            } catch {
                XCTFail("Failed to encode order: \(error.localizedDescription)")
            }

            // Wait for the expectation to be fulfilled
            wait(for: [expectation], timeout: 10.0)
        }




        
    func testPostOrder_Success() {
        // Arrange
        let expectation = self.expectation(description: "API call succeeds")

        let endpoint = "orders.json"
        let url = "https://236f00d0acd3538f6713fd3a323150b6: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@mad44-sv-iost1.myshopify.com/admin/api/2024-04/"
        let address = Address(
            id: nil,
            customerID: nil,
            firstName: "John",
            lastName: "Doe",
            address1: "123 Main St",
            city: "Cairo",
            country: "Egypt",
            phone: "011123456789",
            isDefault: true
        )

        let billingAddress = Address(
            id: nil,
            customerID: nil,
            firstName: "John",
            lastName: "Doe",
            address1: "123 Main St",
            city: "Cairo",
            country: "EG",
            phone: "011123456789",
            isDefault: true
        )

        let testOrder = Order(
            id: 1073460025,
            orderNumber: "#122",
            productNumber: 2,
            address: address,
           // phone: "011123456789",
            date: "2024-05-14T21:19:37-04:00",
            currency: .eur,
            email: UserDefaults.standard.string(forKey: "userEmail") ?? "",
            totalPrice: "290.00",
            items: [
                ItemProductOrder(id: 1071823276, image: "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402", price: "80", quantity: 3, title: "Big Brown Bear Boots"),
                ItemProductOrder(id: 1081823276, image: "https://cdn.shopify.com/s/files/1/0624/0239/6207/collections/97a3b1227876bf099d279fd38290e567.jpg?v=1716812402", price: "50", quantity: 1, title: " Brown Bear Boots")
            ],
            userID: Int(K.Shopify.userID),
            billingAddress: billingAddress,
            customer: UserDefaultsHelper.shared.printUserDefaults()
        )

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let orderData = try encoder.encode(testOrder)
            if let orderDict = try JSONSerialization.jsonObject(with: orderData, options: .mutableContainers) as? [String: Any] {
                NetworkManager.shared.postOrder(url: url, endpoint: endpoint, body: ["order": orderDict])
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { (success, message, responseOrder) in
                        XCTAssertTrue(success, "Expected successful response, but got: \(message ?? "")")
                        XCTAssertEqual(responseOrder?.order.address?.city, testOrder.address?.city)
                        XCTAssertEqual(responseOrder?.order.totalPrice, testOrder.totalPrice)
                        XCTAssertEqual(responseOrder?.order.address?.phone, testOrder.address?.phone)
                        expectation.fulfill()
                    }, onError: { error in
                        XCTFail("Expected successful response, but got error: \(error)")
                    })
                    .disposed(by: disposeBag)
            }
        } catch {
            print("Failed to encode order: \(error.localizedDescription)")
        
    }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 10.0)
    }

    
//    
//    
//    
//    
//    
//    
//    
//   ///////
//    func testPutAPI_Success() throws {
//        // Arrange
//        let customerID = K.Shopify.userID
//        let endpoint = K.endPoints.putOrDeleteAddress.rawValue
//            .replacingOccurrences(of: "{customer_id}", with: customerID)
//            .replacingOccurrences(of: "{address_id}", with: "8249939197999")
//        
//        let address = Address(
//            firstName: "Israa",
//            lastName: "Mhmmd",
//            address1: "13-street",
//            city: "cairo",
//            country: "Egypt",
//            phone: "015515529391"
//        )
//        
//        let jsonData = """
//        {
//            "customer_address": {
//                "id": 8249939197999,
//                "customer_id": 6930899632175,
//                "first_name": "Israa",
//                "last_name": "Mhmmd",
//                "address1": "13-street",
//                "city": "cairo",
//                "country": "Egypt",
//                "phone": "015515529391",
//                "is_default": true
//            }
//        }
//        """.data(using: .utf8)!
//        
//        // Mock session setup
//        mockSession.data = jsonData
//        let expectation = XCTestExpectation(description: "API call succeeds")
//        
//            service.put(endpoint: endpoint, body: ["address": address], responseType: CustomAddress.self)
//                        .observeOn(MainScheduler.instance)
//                        .subscribe(onNext: { (success, message, responseAddress) in
//                            print(success)
//                            print(message)
//                            print(responseAddress)
//                            XCTAssertTrue(success, "Expected successful response, but got: \(message ?? "")")
//                            XCTAssertEqual(responseAddress?.customer_address.city, address.city)
//                            XCTAssertEqual(responseAddress?.customer_address.phone, address.phone)
//                            expectation.fulfill()
//                        }, onError: { error in
//                           
//                XCTFail("Expected successful response, but got error: \(error)")
//            })
//            .disposed(by: disposeBag)
//        
//        // Wait for the expectation to be fulfilled
//        wait(for: [expectation], timeout: 100) // Adjust timeout as needed
//    }


}



// Mock URLSession
class URLSessionMock: URLSession {
    var data: Data?
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        return URLSessionDataTaskMock {
            completionHandler(data, response, nil)
        }
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    override func resume() {
        closure()
    }
}
