//
//  AddressesViewController.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit

class AddressesViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    var viewModel : AddressesViewModel?

    @IBOutlet weak var AddressesTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressesViewModel(network: NetworkManager.shared)
        AddressesTable.dataSource = self
        AddressesTable.delegate = self
        viewModel?.bindAddresses = {
            self.AddressesTable.reloadData()
        }
        viewModel?.getAddressesList()
    }
    

    @IBAction func addNewAddress(_ sender: Any) {
        coordinator?.goToAddressDetails()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }
    
}

extension AddressesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getAddresesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AddressesTable.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        let address = viewModel?.getAddressByIndex(index: indexPath.row)
        cell.textLabel?.text = "\(address?.city ?? "")-\(address?.country ?? "") "
        return cell
    }
    
    
}
