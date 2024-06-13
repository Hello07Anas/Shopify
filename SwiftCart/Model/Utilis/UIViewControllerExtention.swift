//
//  UIViewControllerExtention.swift
//  SwiftCart
//
//  Created by Israa on 12/06/2024.
//

import Foundation
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
}
