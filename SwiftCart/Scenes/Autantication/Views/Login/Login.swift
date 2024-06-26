//
//  Login.swift
//  SwiftCart
//
//  Created by Anas Salah on 31/05/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseCore

class Login: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    weak var coordinator: AppCoordinator?
    var indecator: CustomIndicator? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        indecator = CustomIndicator(containerView: self.view)

        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }

    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
        // TODO: pop from stack "self"
    }

    @IBAction func skipBtn(_ sender: Any) { 
        coordinator?.gotoHome(isThereConnection: true)
    }
    
    @IBAction func dontHaveAcc(_ sender: Any) {
        coordinator?.gotoSignUp(pushToStack: false)
    }

    @IBAction func loginBtn(_ sender: Any) {
        indecator?.start()
        guard let email = emailTF.text, !email.isEmpty,
            let password = passwordTF.text, !password.isEmpty else {

            Utils.showAlert(title: "Error!", message: "Pleas enter both email and password", preferredStyle: .alert, from: self)
            print("Error")
            indecator?.stop()
            return
        }

        guard AuthHelper.isValidEmail(email) else {
            Utils.showAlert(title: "Invalid email", message: "Please enter a valid email address.", preferredStyle: .alert, from: self)
            indecator?.stop()
            return
        }
        
        guard AuthHelper.isValidPassword(password: password) else {
            Utils.showAlert(title: "Invalid password", message: "Password must contain one at least uppercase letter, one lowercase letter, one digit, one special character, and be at least 8 characters long.", preferredStyle: .alert, from: self)
            indecator?.stop()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                Utils.showAlert(title: "Failed to Login", message: error.localizedDescription, preferredStyle: .alert, from: self)
                indecator?.stop()
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
                        
                        print("========\(String(describing: UserDefaultsHelper.shared.getUserData().cartID))")
                        print("========")
                        self.coordinator?.gotoHome(isThereConnection: true)
                        self.indecator?.stop()
                    } else {
                        Utils.showAlert(title: "Account Not Fully Set Up", message: "Your account is not fully set up. Please contact support.", preferredStyle: .alert, from: self)
                        self.indecator?.stop()
                    }
                }
            }
        }
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        indecator?.start()

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print("Error signing in with Google: \(error!.localizedDescription)")
                self.indecator?.stop()
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.indecator?.stop()
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign in error: \(error.localizedDescription)")
                    self.indecator?.stop()
                } else {
                    guard let uid = authResult?.user.uid else { return }
                    let email = user.profile?.email ?? ""
                    let name = user.profile?.name ?? ""
                    
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
                            self.coordinator?.gotoHome(isThereConnection: true)
                            self.indecator?.stop()
                        } else {
                            Utils.showAlert(title: "Error", message: "User data not found. Please sign up first.", preferredStyle: .alert, from: self)
                            self.indecator?.stop()

                        }
                    }
                }
            }
        }
    }
    
    @IBAction func loginWIthX(_ sender: Any) {
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
