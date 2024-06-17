//
//  MyCartViewController.swift
//  SwiftCart
//
//  Created by Israa on 16/06/2024.
//

import UIKit

class CartViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    @IBOutlet weak var totalPrice: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func checkoutBtn(_ sender: Any) {
    }
    
    @IBAction func goToFav(_ sender: Any) {
        coordinator?.goToFav()
    }
}
