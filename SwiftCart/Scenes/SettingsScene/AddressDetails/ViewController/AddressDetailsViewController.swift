//
//  AddressDetailsViewController.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit

class AddressDetailsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    @IBOutlet weak var addressVCTitle: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    

}
