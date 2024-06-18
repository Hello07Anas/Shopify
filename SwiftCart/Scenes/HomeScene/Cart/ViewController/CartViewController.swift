//
//  MyCartViewController.swift
//  SwiftCart
//
//  Created by Israa on 16/06/2024.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    
    let viewModel = CartViewModel(network: NetworkManager.shared)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartTableView.dataSource = self
        cartTableView.delegate = self
        let cellNib = UINib(nibName: "ProductCartCell", bundle: nil)
        cartTableView.register(cellNib, forCellReuseIdentifier: "ProductCartCell")
        
        viewModel.cartObservable
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.cartTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.getCartProductsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCartProductsList()
    }
    
    @IBAction func checkoutBtn(_ sender: Any) {
        // Implement checkout functionality
    }
    
    @IBAction func goToFav(_ sender: Any) {
        coordinator?.goToFav()
    }
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "ProductCartCell", for: indexPath) as! ProductCartCell
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
            guard let self = self else { return }
            let productID = self.viewModel.getCartProductByIndex(index: indexPath.section).variantID
            self.viewModel.deletePrduct(id: productID ?? -1)
        }
        Utils.showAlert(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert, from: self, actions: [deleteAction, cancelAction])
    }
}
