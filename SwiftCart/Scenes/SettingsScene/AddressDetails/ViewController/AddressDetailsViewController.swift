//
//  AddressDetailsViewController.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit

class AddressDetailsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    var viewModel: AddressDetailsViewModel?

    
    @IBOutlet weak var addressVCTitle: NSLayoutConstraint!
    @IBOutlet weak var defaultSwitch: UISwitch!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        country.isUserInteractionEnabled = false
        country.text = "Egypt"
        if viewModel?.isUpdate == true {
            setUpAddressDetails()
        } else {
            setUpAddNewAddress()
        }
        
        viewModel?.alreadyFound = {
            Utils.showAlert(title: "Address Info Error", message: "These address data already exist. Please change the details or go back to the addresses list.", preferredStyle: .alert, from: self)
        }
        
        viewModel?.bindAddress = {
            self.coordinator?.finish()
        }
    
    }
    
    
    func setUpAddressDetails() {
        defaultSwitch.isEnabled = false
        firstName.text = viewModel?.addressDetails?.firstName
        lastName.text = viewModel?.addressDetails?.lastName
        phone.text = viewModel?.addressDetails?.phone
        city.text = viewModel?.addressDetails?.city
        address.text = viewModel?.addressDetails?.address1
        defaultSwitch.isEnabled = true
        if viewModel?.addressDetails?.isDefault == true {
            defaultSwitch.isOn = true
        } else {
            defaultSwitch.isOn = false
        }
    }
    
    func setUpAddNewAddress() {
        defaultSwitch.isOn = false
        defaultSwitch.isEnabled = false
    }
    
    @objc func cityTextFieldTapped() {
        coordinator?.goToCities()
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        guard
            let firstName = firstName.text, !firstName.isEmpty,
            let lastName = lastName.text, !lastName.isEmpty,
            let city = city.text, !city.isEmpty,
            let address = address.text, !address.isEmpty,
            let phone = phone.text, !phone.isEmpty
        else {
            Utils.showAlert(title: "Address", message: "All fields must be not empty.", preferredStyle: .alert, from: self)
            return
        }
        
        guard validatePhoneNumber(phone) else {
            Utils.showAlert(title: "Phone number", message: "Invalid phone number", preferredStyle: .alert, from: self)
            return
        }
        if viewModel?.isUpdate == true {
          viewModel?.updateAddress(firstName: firstName, lastName: lastName, address1: address, city: city, phone: phone)
            if  defaultSwitch.isOn == true {
                viewModel?.setDefaultAddress(firstName: firstName, lastName: lastName, address1: address, city: city, phone: phone)
            }
        } else {
            viewModel?.addNewAddress(firstName: firstName, lastName: lastName, address1: address, city: city, phone: phone)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{11,11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let arrString = Array(phoneNumber)
        return arrString.count > 2 && phoneNumber.first == "0" && arrString[1] == "1" && phoneTest.evaluate(with: phoneNumber)
    }
}
