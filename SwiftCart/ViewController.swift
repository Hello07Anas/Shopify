//
//  ViewController.swift
//  SwiftCart
//
//  Created by Mac on 30/05/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController: ViewDidLoad")
        //_ = ViewModel()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
       _ = HomeViewModel()
    }

}

