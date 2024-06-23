//
//  ShippingViewController.swift
//  SwiftCart
//
//  Created by Israa on 22/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

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
    var viewModel = ShippingViewModel(network: NetworkManager.shared)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        AddressTextField.delegate = self
        viewModel.getCartProductsList()
        viewModel.bindShipping = { [weak self] in
            DispatchQueue.main.async {
                self?.subTotalLabel.text = self?.viewModel.priceBeforeDiscount.formatAsCurrency()
                self?.grandTotalPrice.text = self?.viewModel.GrandPrice.formatAsCurrency()
                
            }
        }
    }


    @IBAction func applyPromocode(_ sender: Any) {
        // Implement promo code application logic here
    }
    
    @IBAction func cashOnDelivery(_ sender: Any) {
        // Implement cash on delivery logic here
        if checkAddressSelected() {
            let totalPrice = Double(viewModel.priceBeforeDiscount)!
            if  totalPrice > K.Shopify.CART_LIMIT_PRICE {
                noCashOnDeliveryAvailable()
            }else{
                
            }
        }
    }
    
    @IBAction func applePay(_ sender: Any) {
        // Implement Apple Pay logic here
        if checkAddressSelected() {
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    
   private func checkAddressSelected() -> Bool {
        if AddressTextField.text?.isEmpty == true {
            Utils.showAlert(title: "Shipping Address", message: "Please, select address before continue!", preferredStyle: .alert, from: self)
            return false
        }
        return true
    }
    
    private func noCashOnDeliveryAvailable() {
        Utils.showAlert(title: "Reached Price Limit", message: "Cash on delivery is not allowed on orders of total price higher than \(String (K.Shopify.CART_LIMIT_PRICE).formatAsCurrency()). Use Apple Pay instead.", preferredStyle: .alert, from: self)
    }
}

extension ShippingViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == AddressTextField) {
            coordinator?.goToAddresses(mode: .select(delegate: self))
            return false
        }
        return true
    }
}

extension ShippingViewController: AddressSelectionDelegate {
    func didSelectAddress(_ address: Address) {
        selectedAddress = address
        AddressTextField.text = "\(address.address1!) - \(address.city!) \\ Egypt"
    }
}

protocol AddressSelectionDelegate: AnyObject {
    func didSelectAddress(_ address: Address)
}

