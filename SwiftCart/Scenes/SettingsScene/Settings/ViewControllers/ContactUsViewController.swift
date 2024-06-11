//
//  ContactUsViewController.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit

class ContactUsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator? // TODO: Dont touch it

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtn(_ sender: Any) {
        
        coordinator?.finish()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
