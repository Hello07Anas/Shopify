//
//  ProductInfoVC.swift
//  SwiftCart
//
//  Created by Anas Salah on 10/06/2024.
//

import UIKit

class ProductInfoVC: UIViewController {

    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel! // e.g "820.25 EGP"
    @IBOutlet weak var productDescription: UITextView!
    // TODO: Add Cosmos in descriprion View
    @IBOutlet weak var descriptionView: UIView!
    // TODO: Add Cosmos in descriprion View

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addToFavBtn(_ sender: Any) {
        // TOOD: Add to FAV
    }
    

    @IBAction func addToCartBtn(_ sender: Any) {
        // TOOD: Add to Cart
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
