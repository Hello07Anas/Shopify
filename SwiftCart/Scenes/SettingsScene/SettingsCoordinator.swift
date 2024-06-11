//
//  SettingsCoordinator.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit

class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let storyboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: nil)
        let settingsVC = storyboard.instantiateViewController(withIdentifier: K.Settings.Settings_View_Name) as! SettingsViewController
        settingsVC.coordinator = self
        navigationController.pushViewController(settingsVC, animated: true)
    }

    func goToContactUs() {
        let storyboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: nil)
        let contactUS = storyboard.instantiateViewController(withIdentifier: K.Settings.Contact_Us_View_Name) as! ContactUsViewController
        contactUS.coordinator = self
        navigationController.pushViewController(contactUS, animated: true)
    }

    func goToAddresses() {
        let storyboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: nil)
        let addressesVC = storyboard.instantiateViewController(withIdentifier: K.Settings.Addresses_View_Name) as! AddressesViewController
        addressesVC.coordinator = self
        navigationController.pushViewController(addressesVC, animated: true)
    }

    func goToAddressDetails() {
        let storyboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: nil)
        let addressDetailsVC = storyboard.instantiateViewController(withIdentifier: K.Settings.Address_Details_View_Name) as! AddressDetailsViewController
        addressDetailsVC.coordinator = self
        navigationController.pushViewController(addressDetailsVC, animated: true)
    }

    func goToCities() {
        // Implement navigation to Cities if needed
    }

    func goToCountries() {
        // Implement navigation to Countries if needed
    }

    func finish() {
        navigationController.popViewController(animated: true)
    }
}
