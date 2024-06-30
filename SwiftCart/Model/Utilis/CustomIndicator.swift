//
//  CustomIndicator.swift
//  SwiftCart
//
//  Created by Anas Salah on 24/06/2024.
//

import UIKit

class CustomIndicator {
    private var activityIndicator: UIActivityIndicatorView?
    private var containerView: UIView?
    
    init(containerView: UIView) {
        self.containerView = containerView
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        guard let containerView = containerView else { return }
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .black
        activityIndicator?.center = containerView.center
        activityIndicator?.hidesWhenStopped = true
        
        containerView.addSubview(activityIndicator!)
    }
    
    func start() {
        guard let activityIndicator = activityIndicator else { return }
        
        activityIndicator.startAnimating()
        containerView?.isUserInteractionEnabled = false
    }
    
    func stop() {
        guard let activityIndicator = activityIndicator else { return }
        
        activityIndicator.stopAnimating()
        containerView?.isUserInteractionEnabled = true
    }
}
