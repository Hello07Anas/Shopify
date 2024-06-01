//
//  LoginVC.swift
//  SwiftCart
//
//  Created by Anas Salah on 31/05/2024.
//

import UIKit

class LoginVC: NibViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backBtn(_ sender: Any) { }

    @IBAction func skipBtn(_ sender: Any) { }
    
    @IBAction func alleadyHaveAcc(_ sender: Any) { }

    @IBAction func sginUp(_ sender: Any) { }

    @IBAction func sginUpWithGoogle(_ sender: Any) { }

    @IBAction func sginUpWithX(_ sender: Any) { }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
