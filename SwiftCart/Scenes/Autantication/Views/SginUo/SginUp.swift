//
//  SginUp.swift
//  SwiftCart
//
//  Created by Anas Salah on 31/05/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SginUp: UIViewController { // TODO: fix routation in Sgin UP
    
    weak var coordinator: AppCoordinator?
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    
    @IBAction func skipBtn(_ sender: Any) {
        coordinator?.gotoHome()
    }
    
    @IBAction func alleadyHaveAcc(_ sender: Any) {
        coordinator?.gotoLogin(pushToStack: false)
    }
    
    @IBAction func sginUp(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passwordTF.text, !password.isEmpty,
              let rePassword = rePasswordTF.text, !rePassword.isEmpty,
              let name = nameTF.text, !name.isEmpty
        else {
            Utils.showAlert(title: "Error", message: "All fileds should be completed", preferredStyle: .alert, from: self)
            return
        }
        
        guard password == rePassword else {
            Utils.showAlert(title: "Invalid password matching!", message: "Passwords do not match", preferredStyle: .alert, from: self)
            return
        }
        
        guard AuthHelper.isValidPassword(password: password) else {
            Utils.showAlert(title: "Invalid password", message: "Password must contain one at least uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long.", preferredStyle: .alert, from: self)
            return
        }
        
        guard AuthHelper.isValidName(name) else {
            Utils.showAlert(title: "Invalid name", message: "pleas enter name between 3 - 20 Character", preferredStyle: .alert, from: self)
            return
        }
        
        guard AuthHelper.isValidEmail(email) else {
            Utils.showAlert(title: "Invalid email", message: "Please enter a valid email address.", preferredStyle: .alert, from: self)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    Utils.showAlert(title: "Error creating user", message: error.localizedDescription, preferredStyle: .alert, from: self)
                    return
                }
                
                guard let uid = authResult?.user.uid else { return }
                
                ShopifyAPIHelper.shared.createCustomer(email: email, firstName: name, lastName: "") { result in
                    switch result {
                    case .success(let shopifyCustomerID):
                        self.createDraftOrders(for: shopifyCustomerID) { draftOrderResult in
                            switch draftOrderResult {
                            case .success(let (cartID, favID)):
                                self.storeUserData(uid: uid, shopifyCustomerID: shopifyCustomerID, email: email, name: name, cartID: cartID, favID: favID) {
                                    self.coordinator?.gotoHome()
                                }
                            case .failure(let error):
                                Utils.showAlert(title: "Error", message: "Failed to create draft orders: \(error.localizedDescription)", preferredStyle: .alert, from: self)
                            }
                        }
                    case .failure(let error):
                        Utils.showAlert(title: "Error", message: "Failed to create Shopify customer: \(error.localizedDescription)", preferredStyle: .alert, from: self)
                    }
                }
            }
        }
    }
    
    @IBAction func sginUpWithGoogle(_ sender: Any) { }
    
    @IBAction func sginUpWithX(_ sender: Any) {}
    
    // Helper Methods:
    
    private func storeUserData(uid: String, shopifyCustomerID: String, email: String, name: String, cartID: String, favID: String, completion: @escaping () -> Void) {
        let numericCustomerID = extractNumericShopifyID(shopifyCustomerID: shopifyCustomerID)
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "uid": uid,
            "shopifyCustomerID": numericCustomerID,
            "email": email,
            "name": name,
            "cartID": cartID,
            "favID": favID
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error writing document: \(error.localizedDescription)")
                    Utils.showAlert(title: "Error", message: "Failed to store user data: \(error.localizedDescription)", preferredStyle: .alert, from: self)
                } else {
                    print("Document successfully written!")
                    UserDefaultsHelper.shared.saveUserData(email: email, name: name, uid: uid, shopifyCustomerID: numericCustomerID, cartID: cartID, favID: favID)
                    completion()
                }
            }
        }
    }

    
    private func createDraftOrders(for shopifyCustomerID: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
        let group = DispatchGroup()
        var draftOrder1ID: String?
        var draftOrder2ID: String?
        var creationError: Error?

        let draftOrder1: [String: Any] = [
            "title": "Fav",
            "price": "0.0",
            "quantity": 1
        ]
        
        let draftOrder2: [String: Any] = [
            "title": "Cart",
            "price": "0.0",
            "quantity": 2
        ]
        
        group.enter()
        ShopifyAPIHelper.shared.createDraftOrder(customerId: shopifyCustomerID, lineItems: [draftOrder1]) { result in
            switch result {
            case .success(let draftOrderId):
                draftOrder1ID = String(draftOrderId)
            case .failure(let error):
                creationError = error
            }
            group.leave()
        }
        
        group.enter()
        ShopifyAPIHelper.shared.createDraftOrder(customerId: shopifyCustomerID, lineItems: [draftOrder2]) { result in
            switch result {
            case .success(let draftOrderId):
                draftOrder2ID = String(draftOrderId)
            case .failure(let error):
                creationError = error
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let error = creationError {
                completion(.failure(error))
            } else if let draftOrder1ID = draftOrder1ID, let draftOrder2ID = draftOrder2ID {
                completion(.success((draftOrder1ID, draftOrder2ID)))
            } else {
                completion(.failure(NSError(domain: "com.swiftcart", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred while creating draft orders"])))
            }
        }
    }



    
    private func extractNumericShopifyID(shopifyCustomerID: String) -> String {
        let prefix = "Customer created with ID: "
        if shopifyCustomerID.hasPrefix(prefix) {
            return String(shopifyCustomerID.dropFirst(prefix.count))
        } else {
            return shopifyCustomerID
        }
    }
}
/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
