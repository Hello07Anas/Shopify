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
        
        bindViewModel()
        viewModel.getCartProductsList()
    }
    
    private func bindViewModel() {
        viewModel.GrandPrice
            .asDriver(onErrorJustReturn: nil)
            .drive(grandTotalPrice.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.priceBeforeDiscount
            .asDriver(onErrorJustReturn: nil)
            .drive(subTotalLabel.rx.text)
            .disposed(by: disposeBag)
    }

    @IBAction func applyPromocode(_ sender: Any) {
        // Implement promo code application logic here
    }
    
    @IBAction func cashOnDelivery(_ sender: Any) {
        // Implement cash on delivery logic here
        checkAddressSelected()
    }
    
    @IBAction func applePay(_ sender: Any) {
        // Implement Apple Pay logic here
        checkAddressSelected()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    
    func checkAddressSelected() {
        if AddressTextField.text?.isEmpty == true {
            Utils.showAlert(title: "Shipping Address", message: "Please select address before continue!", preferredStyle: .alert, from: self)
        }
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

