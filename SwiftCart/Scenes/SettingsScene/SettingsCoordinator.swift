//
//  SettingsCoordinator.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit
import Reachability
class SettingsCoordinator: Coordinator {
    let reachability = try! Reachability()
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: AppCoordinator?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        setupReachability()
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
    
    func goToAddresses(mode: AddressesMode = .manage) {
        let storyboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: nil)
        let addressesVC = storyboard.instantiateViewController(withIdentifier: K.Settings.Addresses_View_Name) as! AddressesViewController
        addressesVC.coordinator = self
        addressesVC.mode = mode
        navigationController.pushViewController(addressesVC, animated: true)
    }
    
    func goToAddAddress() {
        let storyboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: nil)
        let addressDetailsVC = storyboard.instantiateViewController(withIdentifier: K.Settings.Address_Details_View_Name) as! AddressDetailsViewController
        addressDetailsVC.coordinator = self
        addressDetailsVC.viewModel = AddressDetailsViewModel(addressDetails: Address(), isUpdate: false)
        navigationController.pushViewController(addressDetailsVC, animated: true)
    }
    
    func goToAddressDetails(address: Address) {
        let storyboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: nil)
        let addressDetailsVC = storyboard.instantiateViewController(withIdentifier: K.Settings.Address_Details_View_Name) as! AddressDetailsViewController
        addressDetailsVC.coordinator = self
        addressDetailsVC.viewModel = AddressDetailsViewModel(addressDetails: address, isUpdate: true)
        navigationController.pushViewController(addressDetailsVC, animated: true)
    }
    
    func goToCurrency() {
        let storyboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: nil)
        let currencyVC = storyboard.instantiateViewController(withIdentifier: K.Settings.Currency_View_Name) as! CurrencyViewController
        currencyVC.modalPresentationStyle = .overCurrentContext
        currencyVC.coordinator = self
        navigationController.present(currencyVC, animated: false)
    }
    
    func presentCitiesViewController(from viewController: UIViewController, onCitySelected: @escaping (String) -> Void) {
        let citiesVC = CitiesViewController()
        citiesVC.onCitySelected = onCitySelected
        let navController = UINavigationController(rootViewController: citiesVC)
        viewController.present(navController, animated: true, completion: nil)
    }
    
    
    func finish() {
        navigationController.popViewController(animated: true)
    }
    
    func setupReachability() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func isNetworkReachable() -> Bool {
        return reachability.connection != .unavailable
    }
}
