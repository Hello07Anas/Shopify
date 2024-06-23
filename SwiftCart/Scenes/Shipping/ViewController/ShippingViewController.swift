//
//  ShippingViewController.swift
//  SwiftCart
//
//  Created by Israa on 22/06/2024.
//

import UIKit

class ShippingViewController: UIViewController {
    @IBOutlet weak var discountPercentage: UILabel!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var grandTotalPrice: UILabel!
    @IBOutlet weak var AddressTextField: UITextField!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var promocodeTextField: UITextField!
    var coordinator: SettingsCoordinator?
    var selectedAddress: Address?

    override func viewDidLoad() {
        super.viewDidLoad()
        AddressTextField.delegate = self
    }
    
    @IBAction func allpyPromocode(_ sender: Any) {
        // Implement promo code application logic here
    }
    
    @IBAction func cashOndelivery(_ sender: Any) {
        // Implement cash on delivery logic here
    }
    
    @IBAction func applePay(_ sender: Any) {
        // Implement Apple Pay logic here
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
}

extension ShippingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == AddressTextField {
            coordinator?.goToAddresses(mode: .select(delegate: self))
            return false
        }
        return true
    }
}

extension ShippingViewController: AddressSelectionDelegate {
    func didSelectAddress(_ address: Address) {
        selectedAddress = address
        AddressTextField.text = "\(address.address1!) - \(address.city!)"
    }
}

protocol AddressSelectionDelegate: AnyObject {
    func didSelectAddress(_ address: Address)
}
