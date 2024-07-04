//
//  SettingsViewController.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    weak var coordinator: SettingsCoordinator?
    @IBOutlet weak var settingsList: UITableView!
    @IBOutlet weak var logOutLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.navigationBar.isHidden = true
        settingsList.delegate  = self
        settingsList.dataSource = self
        updateLogOutLoginButton()
    }
    
    @IBAction func logOut(_ sender: Any) {
        // TODO: handle LogOut --> Anas entry Point مهو اي حاجة اعمل يا انس
        let userData = UserDefaultsHelper.shared.getUserData()
        
        if userData.email != nil {
            do {
                try Auth.auth().signOut()
                
                let okBtn = UIAlertAction(title: "OK", style: .default) { _ in
                    self.coordinator?.parentCoordinator?.gotoHome(isThereConnection: Utils.isNetworkReachableTest())
                }
                let cancle = UIAlertAction(title: "CANCLE", style: .default) { _ in
                    
                }
                Utils.showAlert(title: "Will miss you \(userData.name!)🥹", message: "See you soon!🥲", preferredStyle: .alert, from: self, actions: [okBtn,cancle])
                logOutLoginBtn.setTitle("Login", for: .normal)
                
                UserDefaultsHelper.shared.clearUserData()
                UserDefaults.standard.removeObject(forKey: "userUID")
                
                clearAllUserDefaults()
                print("====UserDefaultsHelper.shared.printAllUserDefaults() ====")
                UserDefaultsHelper.shared.printAllUserDefaults()
                print("====UserDefaultsHelper.shared.printAllUserDefaults() ====")

            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
                Utils.showAlert(title: "Error!", message: "Sorry, something went wrong. Please try again later.", preferredStyle: .alert, from: self)
            }
        } else {
            coordinator?.parentCoordinator?.gotoLogin(pushToStack: true)
            logOutLoginBtn.setTitle("Logout", for: .normal)
        }
    }
    
    private func clearAllUserDefaults() { // عشان زهقت بس ياريت ينفع
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    
    private func updateLogOutLoginButton() {
        let userData = UserDefaultsHelper.shared.getUserData()
        
        if userData.email != nil || userData.name != nil {
            logOutLoginBtn.setTitle("Logout", for: .normal)
        } else {
            logOutLoginBtn.setTitle("Login", for: .normal)
        }
    }
    
}

extension SettingsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            cell.textLabel?.text =   "My Addresses"
            cell.textLabel?.textColor = .darkGray
            return cell
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            cell.textLabel?.text =  "Currency"
            cell.textLabel?.textColor = .darkGray

            return cell
        case 2:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            cell.textLabel?.text = "About US"
            cell.textLabel?.textColor = .darkGray

            return cell
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            cell.textLabel?.text =  "Contact US"
            cell.textLabel?.textColor = .darkGray

            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return tableView.frame.height * 0.25
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row{
        case 0:
            coordinator?.goToAddresses(mode: .manage)
        case 1:
            coordinator?.goToCurrency()
        case 2:
            coordinator?.goToAboutUs()
            return
        default:
            coordinator?.goToContactUs()
        }

    }
    
}


/*
 
// Anas77@gmail.com

Home
 search
 products
 add to fav
 filter
 
Categories
 add to Fav
 filter
 search
 add to fav
 goto details
 
ProductINfo
 zoom
 add to cart
 
Cart
 delete from cart
 
 complete buy
 
Profile
 see orders
 see whishList
 
Settings
 Address
 Currncy
 ContactUs
 */
