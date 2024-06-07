//
//  Coordinator.swift
//  SwiftCart
//
//  Created by Anas Salah on 07/06/2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func finish()
}
