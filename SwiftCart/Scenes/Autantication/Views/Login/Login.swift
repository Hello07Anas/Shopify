//
//  Login.swift
//  SwiftCart
//
//  Created by Anas Salah on 31/05/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class Login: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    weak var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationController?.navigationBar.isHidden = true

    }

    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
        // TODO: pop from stack "self"
    }

    @IBAction func skipBtn(_ sender: Any) { 
        coordinator?.gotoHome()
    }
    
    @IBAction func dontHaveAcc(_ sender: Any) {
        coordinator?.gotoSignUp(pushToStack: false)
    }

    @IBAction func loginBtn(_ sender: Any) {
        guard let email = emailTF.text, !email.isEmpty,
            let password = passwordTF.text, !password.isEmpty else {

            Utils.showAlert(title: "Error!", message: "Pleas enter both email and password", preferredStyle: .alert, from: self)
            print("Error")
            return
        }

        guard AuthHelper.isValidEmail(email) else {
            Utils.showAlert(title: "Invalid email", message: "Please enter a valid email address.", preferredStyle: .alert, from: self)
            return
        }
        
        guard AuthHelper.isValidPassword(password: password) else {
            Utils.showAlert(title: "Invalid password", message: "Password must contain one at least uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long.", preferredStyle: .alert, from: self)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                Utils.showAlert(title: "Failed to Login", message: error.localizedDescription, preferredStyle: .alert, from: self)
            } else {
                print("Login Successful")
                
                self.fetchUserDataFromFirestore(email: email) { userData in
                    if let userData = userData {
                        UserDefaultsHelper.shared.saveUserData(
                            email: email,
                            name: userData["name"] as? String ?? "",
                            uid: userData["uid"] as? String ?? "",
                            shopifyCustomerID: userData["shopifyCustomerID"] as? String ?? "",
                            cartID: userData["cartID"] as? String ?? "",
                            favID: userData["favID"] as? String ?? ""
                        )
                        
                        print("========")
                        UserDefaultsHelper.shared.printUserDefaults()
                        print("========")
                        self.coordinator?.gotoHome()
                        
                    } else {
                        Utils.showAlert(title: "Account Not Fully Set Up", message: "Your account is not fully set up. Please contact support.", preferredStyle: .alert, from: self)
                    }
                }
            }
        }
    }
    
    // Helper methods
    
    private func fetchUserDataFromFirestore(email: String, completion: @escaping ([String: Any]?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user data from Firestore: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents, let userData = documents.first?.data() else {
                print("No user data found for email: \(email)")
                completion(nil)
                return
            }
            completion(userData)
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
