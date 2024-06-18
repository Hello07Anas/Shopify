//
//  MyCartViewController.swift
//  SwiftCart
//
//  Created by Israa on 16/06/2024.
//

import UIKit

class CartViewController: UIViewController {
    weak var coordinator: AppCoordinator?
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    
    let viewModel = CartViewModel(network: NetworkManager.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartTableView.dataSource = self
        cartTableView.delegate = self
        let cellNib = UINib(nibName: "ProductCartCell", bundle: nil)
        cartTableView.register(cellNib, forCellReuseIdentifier: "ProductCartCell")
        
        viewModel.bindCartProducts = {
            [weak self] in
                self?.cartTableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getCartProductsList()
    }
    
    @IBAction func checkoutBtn(_ sender: Any) {
    }
    
    @IBAction func goToFav(_ sender: Any) {
        coordinator?.goToFav()
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "ProductCartCell", for: indexPath) as! ProductCartCell
        viewModel.configCell(cell, at: indexPath.section)
        print(cell.cellID ?? -1)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  viewModel.getCartProductCount()
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
}
