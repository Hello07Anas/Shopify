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
    var indecator: CustomIndicator?

    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var labelView1: UILabel!
    @IBOutlet weak var labelView2: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var emptyOrdersListImg: UIImageView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var checkOutStak: UIStackView!
    var noConnectionCase = TestPojo(img: "No-Internet--Streamline-Bruxelles", title: "Whooops!", dec: "No internet connection found check your connection.", btnTitle: "TRY AGAIN")
    var notLoggedInCase = TestPojo(img: "No-Search-Results-Found-2--Streamline-Bruxelles", title: "Not Logged In", dec: "Please log in to access this feature.", btnTitle: "Log In")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indecator = CustomIndicator(containerView: view.self)
        indecator?.start()
        
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
        viewModel.getCartProductsList(completion: {_ in
            self.indecator?.stop()
        })
        
    }
    
    @IBAction func checkCase(_ sender: Any) {
        if !Utils.isNetworkReachableTest(){
            coordinator?.gotoHome(isThereConnection: Utils.isNetworkReachableTest())
        }
        else if(UserDefaultsHelper.shared.getUserData().name == nil){
            coordinator?.gotoLogin(pushToStack: true)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!(Utils.isNetworkReachableTest())){
            checkView.isHidden = false
            imgView.image = UIImage(named: noConnectionCase.img)
            labelView1.text = noConnectionCase.title
            labelView2.text = noConnectionCase.dec
            checkBtn.setTitle(noConnectionCase.btnTitle, for: .normal)
            
        }
        else if(UserDefaultsHelper.shared.getUserData().name == nil){
            checkView.isHidden = false
            imgView.image = UIImage(named: notLoggedInCase.img)
            labelView1.text = notLoggedInCase.title
            labelView2.text = notLoggedInCase.dec
            checkBtn.setTitle(notLoggedInCase.btnTitle, for: .normal)
            
        }
        else{
            checkView.isHidden = true
            
        }
        viewModel.bindCartProducts = { [weak self] in
            DispatchQueue.main.async {
                self?.cartTableView.reloadData()
              
            }
        }
        viewModel.getCartProductsList(completion: {_ in
            self.indecator?.stop()
        })    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.bindCartProducts = { [weak self] in
            DispatchQueue.main.async {
            
                self?.cartTableView.reloadData()
            }
        }
        viewModel.getCartProductsList(completion: {_ in
            self.indecator?.stop()
        })
    }

    @IBAction func checkoutBtn(_ sender: Any) {
        
        coordinator?.goToShipping()
    }
    
    @IBAction func goToFav(_ sender: Any) {
        coordinator?.goToFav()
    }
    
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate, ProductCartCellDelegate {

    

    func didUpdateProductQuantity(forCellID id: Int, with quantity: Int, completion: ((Bool) -> Void)? = nil) {
//        indecator?.start()
        print("didUpdateProductQuantity IN")

        if quantity < 1 {
            print("if quantity < 1")
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
                self?.indecator?.stop()
                completion?(false)
            })
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.viewModel.deleteProduct(id: id, completion: {_ in
                    self?.indecator?.stop()
                })
            }
            Utils.showAlert(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert, from: self, actions: [deleteAction, cancelAction])
        } else {
            print("} else {")
            viewModel.updateLineItemQuantity(variantID: id, newQuantity: quantity) { success in
                print("viewModel.updateLineItemQuantity(variantID: id, newQuantity: quantity)is ....  \(success)")
                self.indecator?.stop()
                completion?(success)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "ProductCartCell", for: indexPath) as! ProductCartCell
        cell.delegate = self
        viewModel.configCell(cell, at: indexPath.section)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = viewModel.getCartProductCount()
       emptyOrdersListImg.isHidden = count > 0
        checkOutStak.isHidden = count == 0
        return count
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
        self.indecator?.start()

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {_ in
            self.indecator?.stop()
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteProduct(id: self?.viewModel.getCartProductByIndex(index: indexPath.section).variantID ?? -1, completion: {_ in
                self?.indecator?.stop()
            })
        }
        Utils.showAlert(title: "Delete", message: "Are you sure you want to delete this item?", preferredStyle: .alert, from: self, actions: [deleteAction, cancelAction])
    }
}
