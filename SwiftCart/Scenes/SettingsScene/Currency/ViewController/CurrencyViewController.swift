//
//  CurrencyViewController.swift
//  SwiftCart
//
//  Created by Israa on 20/06/2024.
//

import UIKit

class CurrencyViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    var selectedButton: UIButton?
    var filledImage = UIImage(systemName: K.customRadioButton.filled.rawValue)
    var unfilledImage = UIImage(systemName: K.customRadioButton.unFilled.rawValue)
    var viewModel = CurrencyViewModel()
    
    @IBOutlet weak var usd: UIButton!
    @IBOutlet weak var egp: UIButton!
    @IBOutlet weak var sar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        setupButtons()
        updateSelectedButton()
    }
    
    func setupButtons() {
        egp.setImage(unfilledImage, for: .normal)
        sar.setImage(unfilledImage, for: .normal)
        usd.setImage(unfilledImage, for: .normal)
    }
    
    func updateSelectedButton() {
        let selectedCurrency = viewModel.getTheSelectedCurrency()
        switch selectedCurrency.uppercased() {
        case K.Currency.egp.rawValue.uppercased():
            handleButtonTap(egp, shouldFetchData: false)
        case K.Currency.SAR.rawValue.uppercased():
            handleButtonTap(sar, shouldFetchData: false)
        case K.Currency.USD.rawValue.uppercased():
            handleButtonTap(usd, shouldFetchData: false)
        default:
            break
        }
    }
    
    @IBAction func egpBtn(_ sender: Any) {
        handleButtonTap(egp)
    }
    
    @IBAction func sarBtn(_ sender: Any) {
        handleButtonTap(sar)
    }
    
    @IBAction func usdBtn(_ sender: Any) {
        handleButtonTap(usd)
    }
    
    func handleButtonTap(_ button: UIButton, shouldFetchData: Bool = true) {
        guard button != selectedButton else { return }
        
        button.setImage(filledImage, for: .normal)
        selectedButton?.setImage(unfilledImage, for: .normal)
        selectedButton = button
        
        if shouldFetchData {
            guard let currencyType = button.titleLabel?.text else {
                print("Button title is nil")
                return
            }
            let normalizedCurrencyType = currencyType.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.fetchCurrencyDataAndStore(currencyType: normalizedCurrencyType) { success, error in
                if success {
                    print("\(normalizedCurrencyType) data updated and stored successfully")
                } else {
                    print("Failed to update \(normalizedCurrencyType) data: \(error ?? "Unknown error")")
                }
                UserDefaultsHelper.shared.saveCurrencyType(currencyType: normalizedCurrencyType)
            }

        }
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
