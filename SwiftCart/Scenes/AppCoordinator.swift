//
//  AppCoordinator.swift
//  SwiftCart
//
//  Created by Anas Salah on 07/06/2024.
//

import UIKit
import Reachability

class AppCoordinator: Coordinator {
    let reachability = try! Reachability()

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupReachability()
    }
    
    func start() {
        navigationController.navigationBar.isHidden = true
        
        if UserDefaultsHelper.shared.getUserData().email == nil {
            let storyboard = UIStoryboard(name: K.Home.Home_Storyboard_Name, bundle: Bundle.main)
            let onBoardingVc = storyboard.instantiateViewController(withIdentifier: K.Home.OnBoarding_View_Name) as! OnBoardingScreenViewController
            
            onBoardingVc.coordinator = self
            navigationController.pushViewController(onBoardingVc, animated: true)
        } else {
            getStarted()
        }
    }
    
    func getStarted(){
       
            if UserDefaultsHelper.shared.getUserData().email == nil {
                gotoLogin(pushToStack: true)
            } else if UserDefaultsHelper.shared.getUserData().email != nil {
                gotoHome(isThereConnection: Utils.isNetworkReachableTest() )
            }
        
       
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
    
    func gotoHome( isThereConnection:  Bool) {
       // isThereConnection = isNetworkReachable()
        if let homeVC = navigationController.viewControllers.last(where: { $0 is HomeViewController }) { // TODO: Bougs here we not remove from stack we have to handle it
            navigationController.popToViewController(homeVC, animated: true)
        } else {
            let storyboard = UIStoryboard(name: K.Home.Home_Storyboard_Name, bundle: Bundle.main)
            let settingsStoryboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: Bundle.main)
            let homeVc = storyboard.instantiateViewController(withIdentifier: K.Home.Home_View_Name) as! HomeViewController
            
            let categoryVc = storyboard.instantiateViewController(withIdentifier: K.Home.Category_View_Name) as! CategoryViewController
            let myCartVC = settingsStoryboard.instantiateViewController(withIdentifier: K.Settings.Cart_View_Name) as! CartViewController
            let profileVC = settingsStoryboard.instantiateViewController(withIdentifier: K.Settings.Profile_View_Name) as! ProfileViewController
            
           
            homeVc.coordinator = self
         //   homeVc.isInternetConnection = isNetworkReachable()
            categoryVc.coordinator = self
           // categoryVc.isInternetConnection = isNetworkReachable()
            myCartVC.coordinator = self
            profileVC.coordinator = self
            
            
            homeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
            categoryVc.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "list.bullet"), tag: 1)
            myCartVC.tabBarItem = UITabBarItem(title: "MyCart", image: UIImage(systemName: "cart"), tag:2)
            profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag:3)
            
            let tabBar = UITabBarController()
            tabBar.viewControllers = [homeVc, categoryVc, myCartVC, profileVC]
            tabBar.tabBar.backgroundColor = .white
            
            navigationController.pushViewController(tabBar, animated: true)
        }
    }
    
    func goToProducts(brandID:Int) {
        if Utils.isNetworkReachableTest()  {
            let storyboard = UIStoryboard(name: K.Home.Home_Storyboard_Name, bundle: Bundle.main)
            let productVc = storyboard.instantiateViewController(withIdentifier: K.Home.Product_View_Name) as! ProductViewController
            
            productVc.coordinator = self
            productVc.brandID = brandID
            
            navigationController.pushViewController(productVc, animated: true)
        } else {
        Utils.showAlert(title: "No Internet Connection",
                        message: "Please check your network settings and try again.",
                        preferredStyle: .alert,
                        from: navigationController)
        }
    }
    
    func goToOrders() {
        if Utils.isNetworkReachableTest()  {
            let storyboard = UIStoryboard(name: K.Home.Home_Storyboard_Name, bundle: Bundle.main)
            let orderVc = storyboard.instantiateViewController(withIdentifier: K.Settings.Order_View_Name) as! OrderViewController
            
            orderVc.coordinator = self
            
            navigationController.pushViewController(orderVc, animated: true)
        } else {
            Utils.showAlert(title: "No Internet Connection",
                            message: "Please check your network settings and try again.",
                            preferredStyle: .alert,
                            from: navigationController)
        }
    }
    func goToOrdersDerails(orderDetails: Order) {
     
            let storyboard = UIStoryboard(name: K.Home.Home_Storyboard_Name, bundle: Bundle.main)
        let orderDetailsVc = storyboard.instantiateViewController(withIdentifier: K.Settings.OrderDetails_View_Name) as! OrderDetailsViewController
            
            orderDetailsVc.coordinator = self
            orderDetailsVc.orderDetails = orderDetails
            
            navigationController.pushViewController(orderDetailsVc, animated: true)
      
    }
    
    func goToSettings() {
        let settingsCoordinator = SettingsCoordinator(navigationController: navigationController, parentCoordinator: self)
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
    }
 
    func goToProductInfo(productId: Int, isFav: Bool) {
        if Utils.isNetworkReachableTest()  {
            let productInfoVC = ProductInfoVC(nibName: "ProductInfoVC", bundle: Bundle.main)
            productInfoVC.coordinator = self
            productInfoVC.id = productId
            productInfoVC.isFavorited = isFav
            
            let productInfoVM = ProductInfoVM()
            productInfoVC.productInfoVM = productInfoVM
            productInfoVM.fetchProduct(with: productId)
            
            navigationController.pushViewController(productInfoVC, animated: true)
        } else {
            Utils.showAlert(title: "No Internet Connection",
                            message: "Please check your network settings and try again.",
                            preferredStyle: .alert,
                            from: navigationController)
        }
    }

    func goToFav() {
        if Utils.isNetworkReachableTest() {
            if UserDefaultsHelper.shared.getUserData().name == nil {
                let sginUp = UIAlertAction(title: "Create Account", style: .default, handler: { _ in self.gotoSignUp(pushToStack: true)
                })
                let login = UIAlertAction(title: "Login to My Account", style: .default, handler: { _ in self.gotoLogin(pushToStack: true)
                })

                let destructiveAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
                
                Utils.showAlert(title: "Sorry :(", message: "Please login to open this feature", preferredStyle: .actionSheet, from: navigationController, actions: [sginUp, login, destructiveAction])
            } else {
                let fav = FavVC(nibName: "FavVC", bundle: nil)
                fav.coordinator = self
                navigationController.pushViewController(fav, animated: true)
            }
        } else {
            Utils.showAlert(title: "No Internet Connection",
                            message: "Please check your network settings and try again.",
                            preferredStyle: .alert,
                            from: navigationController)
        }
    }
        
    func finish() {
        if Utils.isNetworkReachableTest(){
            navigationController.popViewController(animated: true)
        } else {
            gotoHome(isThereConnection: isNetworkReachable())
        }
    }
    
    func goToImageZoom(imageURLs: [URL], selectedImageURL: URL?) {
        let imageZoomVC = ImageZoom(imageURLs: imageURLs, selectedImageURL: selectedImageURL)
        imageZoomVC.coordinator = self
        navigationController.pushViewController(imageZoomVC, animated: true)
    }
 
    func goToShipping() {
        let storyboard = UIStoryboard(name: K.Settings.Settings_Storyboard_Name, bundle: nil)
        let shippingVC = storyboard.instantiateViewController(withIdentifier: K.Settings.shipping_View_Name) as! ShippingViewController
        shippingVC.coordinator = SettingsCoordinator(navigationController: navigationController, parentCoordinator: self)
        navigationController.pushViewController(shippingVC, animated: true)
    }
    
    // reachabilty
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


//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController

//        let mainViewController = Login(nibName: "Login", bundle: Bundle.main)
//        mainViewController.coordinator = self
//        navigationController.pushViewController(mainViewController, animated: false)
