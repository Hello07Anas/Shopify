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
                Utils.showAlert(title: "will miss you \(userData.name!)🥹", message: "See you soon!🥲", preferredStyle: .alert, from: self, actions: [okBtn])
                logOutLoginBtn.setTitle("Login", for: .normal)
                UserDefaultsHelper.shared.clearUserData()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
                Utils.showAlert(title: "Error!", message: "soory somethign went roung pleas try again later", preferredStyle: .alert, from: self)
            }
        } else {
            coordinator?.parentCoordinator?.gotoLogin(pushToStack: true)
            logOutLoginBtn.setTitle("Logout", for: .normal)
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
