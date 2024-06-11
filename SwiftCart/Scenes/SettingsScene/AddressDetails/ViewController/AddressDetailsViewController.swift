//
//  AddressDetailsViewController.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit

class AddressDetailsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    var viewModel : AddressDetailsVM?

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
        if viewModel?.isUpdate == true {
          setUpAddressDetails()
        } else {
            setUpAddNewAddress()
        }
    }
    
    func setUpAddressDetails() {
        defaultSwitch.isEnabled = false
        firstName.text = viewModel?.addressDetails?.firstName
        lastName.text = viewModel?.addressDetails?.lastName
        phone.text = viewModel?.addressDetails?.phone
        city.text = viewModel?.addressDetails?.city
        country.text = viewModel?.addressDetails?.country
        address.text = viewModel?.addressDetails?.address1
        if viewModel?.addressDetails?.isDefault == true {
            defaultSwitch.isOn = true
        }
    }
    func setUpAddNewAddress(){
        defaultSwitch.isOn = false
        city.isUserInteractionEnabled = false
        country.isUserInteractionEnabled = false
    }

    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    

}
