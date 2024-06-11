//
//  AppCoordinator.swift
//  SwiftCart
//
//  Created by Anas Salah on 07/06/2024.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController

        let mainViewController = Login(nibName: "Login", bundle: Bundle.main)
        mainViewController.coordinator = self

        navigationController.pushViewController(mainViewController, animated: false)

//        self.goToSettings()
    }
    
    func gotoLogin(pushToStack: Bool) {
        if let loginViewController = navigationController.viewControllers.last(where: { $0 is Login }), !pushToStack {
            navigationController.popToViewController(loginViewController, animated: true)
        } else {
            let login = Login(nibName: K.Auth.Login_Nib_Name, bundle: nil)
            login.coordinator = self
            navigationController.pushViewController(login, animated: true)
        }
    }
    
    func gotoSignUp(pushToStack: Bool) {
        
        if let sginUpViewController = navigationController.viewControllers.last(where: { $0 is SginUp }), !pushToStack {
            navigationController.popToViewController(sginUpViewController, animated: true)
        } else {
            let sginUp = SginUp(nibName: K.Auth.SginUp_Nib_Name, bundle: nil)
            sginUp.coordinator = self
            navigationController.pushViewController(sginUp, animated: true)
        }
    }
    
    
    func gotoHome() {
        
        let storyboard = UIStoryboard(name: K.Home.Home_Storyboard_Name, bundle: Bundle.main)
        let homeVc = storyboard.instantiateViewController(withIdentifier: K.Home.Home_View_Name) as! HomeViewController
        let categoryVc = storyboard.instantiateViewController(withIdentifier: K.Home.Category_View_Name) as! CategoryViewController
        homeVc.coordinator = self
        categoryVc.coordinator = self
        
        homeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        categoryVc.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeVc, categoryVc]
        tabBar.tabBar.backgroundColor = .white
        
        navigationController.pushViewController(tabBar, animated: true)
    }
    
    func goToProducts(brandID:Int) {
        
        let storyboard = UIStoryboard(name: K.Home.Home_Storyboard_Name, bundle: Bundle.main)
        let productVc = storyboard.instantiateViewController(withIdentifier: K.Home.Product_View_Name) as! ProductViewController
        
        productVc.coordinator = self
        productVc.brandID = brandID
        
        navigationController.pushViewController(productVc, animated: true)
    }
    
    func goToSettings() {
           let settingsCoordinator = SettingsCoordinator(navigationController: navigationController)
           childCoordinators.append(settingsCoordinator)
           settingsCoordinator.start()
       }
 
    func goToProductInfo(product:Any) {
        let productInfoVC = ProductInfoVC(nibName: "ProductInfoVC", bundle: Bundle.main)
        productInfoVC.coordinator = self
        productInfoVC.productInfoVM = ProductInfoVM(product: product as! Product)
        navigationController.pushViewController(productInfoVC, animated: false)
        
        //print("=== GO TO Product Info ===")
    }
        
    func finish() {
        navigationController.popViewController(animated: true)
    }
}


//    func gotoProductInfo(product: Any) {
//    let productInfoVC = ProductInfoVC(nibName: "ProductInfoVC", bundle: Bundle.main)
//    productInfoVC.coordinator = self
//    productInfoVC.productInfoVM = ProductInfoVM(product: product)
//    navigationController.pushViewController(productInfoVC, animated: false)
//    }
