//
//  MyCartViewController.swift
//  SwiftCart
//
//  Created by Israa on 16/06/2024.
//

import UIKit

class CartViewController: UIViewController {
    
    weak var coordinator: AppCoordinator?
    let viewModel = CartViewModel(network: NetworkManager.shared)

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartTableView.dataSource = self
        cartTableView.delegate = self
        let cellNib = UINib(nibName: "ProductCartCell", bundle: nil)
        cartTableView.register(cellNib, forCellReuseIdentifier: "ProductCartCell")
        
        viewModel.bindCartProducts = { [weak self] in
            DispatchQueue.main.async {
                self?.cartTableView.reloadData()
            }
        }
        viewModel.updateTotalPrice = { [weak self] totalPriceText in
            DispatchQueue.main.async {
                self?.totalPrice.text = totalPriceText.formatAsCurrency()
            }
        }
        viewModel.bindMaxLimitQuantity = {
            Utils.showAlert(title: "Warning", message: "You have reached max limit of quantity.", preferredStyle: .alert, from: self)
        }
        viewModel.getCartProductsList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCartProductsList()
    }
    
    @IBAction func checkoutBtn(_ sender: Any) {
        coordinator?.goToShipping()
    }
    
    @IBAction func goToFav(_ sender: Any) {
        //coordinator?.goToFav()
    }
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate, ProductCartCellDelegate {
    func didUpdateProductQuantity(forCellID id: Int, with quantity: Int) {
        if quantity < 1 {
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.viewModel.deleteProduct(id: id)
            }
            Utils.showAlert(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert, from: self, actions: [deleteAction, cancelAction])
        } else {
            viewModel.updateLineItemQuantity(variantID: id, newQuantity: quantity)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "ProductCartCell", for: indexPath) as! ProductCartCell
        cell.delegate = self
        viewModel.configCell(cell, at: indexPath.section)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getCartProductCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteProduct(id: self?.viewModel.getCartProductByIndex(index: indexPath.section).variantID ?? -1)
        }
        Utils.showAlert(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert, from: self, actions: [deleteAction, cancelAction])
    }
}
