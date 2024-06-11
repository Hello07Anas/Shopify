//
//  SettingsViewController.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit

class SettingsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?

    @IBOutlet weak var settingsList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        settingsList.delegate  = self
        settingsList.dataSource = self
    }
    
    @IBAction func logOut(_ sender: Any) {
        // TODO: handle LogOut --> Anas entry Point
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
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
            coordinator?.goToAddresses()
        case 1:
            // TODO: handle cuurency
          return
        case 2:
            // TODO: handle About Us
            return
        default:
            coordinator?.goToContactUs()
        }

    }
    
}
