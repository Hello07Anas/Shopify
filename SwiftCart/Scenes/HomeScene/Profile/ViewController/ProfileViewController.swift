//
//  ProfileViewController.swift
//  SwiftCart
//
//  Created by Israa on 17/06/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOrderView()
        setupUserView()
        userName.text = "Welcome, \(String(describing: UserDefaultsHelper.shared.getUserData().name ?? ""))👋"
        email.text = UserDefaultsHelper.shared.getUserData().email
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func gotoSettings(_ sender: Any) {
        coordinator?.goToSettings()
    }
    @IBAction func showOrderList(_ sender: Any) {
    }
    @IBAction func showWishlist(_ sender: Any) {
    }
    
    
    
    private func setupOrderView() {
        orderView.layer.borderColor = UIColor.black.cgColor
        orderView.layer.borderWidth = 1.0
        orderView.layer.cornerRadius = 10.0
        orderView.layer.masksToBounds = true
    }
    private func setupUserView() {
        userView.layer.borderColor = UIColor.black.cgColor
        userView.layer.borderWidth = 0.0
        userView.layer.cornerRadius = 10.0
        userView.layer.masksToBounds = true
    }
    
}
