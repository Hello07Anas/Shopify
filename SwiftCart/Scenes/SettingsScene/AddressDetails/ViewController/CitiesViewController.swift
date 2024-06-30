//
//  CitiesViewController.swift
//  SwiftCart
//
//  Created by Israa on 12/06/2024.
//

import UIKit

class CitiesViewController: UITableViewController {
    var cities = ["Cairo", "Alexandria", "Giza", "Al Sharqia", "Al-Dakahlia", "Al-Beheira", "Al-Monufia", "Al-Gharbia", "Kafr-El-Sheikh", "Damietta", "Port-Said", "Ismailia", "Suez", "North-Sinai", "South-Sinai", "Beni-Suef", "Faiyum", "Minya", "Asyut", "Sohag", "Qena", "Luxor", "Aswan", "Red-Sea", "Al-Wadi Al-Jadid", "Marsa-Matrouh"]
    var onCitySelected: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select City"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.leftBarButtonItem = doneButton
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        onCitySelected?(selectedCity)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
