//
//  NibViewController.swift
//  SwiftCart
//
//  Created by Anas Salah on 31/05/2024.
//

import Foundation
import UIKit

open class NibViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable,
                message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable,
                message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    }
    
    open override func loadView() {
        
        // Bundle
        let bundle = Bundle(for: type(of: self))
        // Nib file name should match with UIViewController name
        let nibName = String(describing: type(of: self))
        
        // Initiate Nib files
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        // Generate UIView
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("The loaded nib view is not available either the Nib file does not exsist or The nib file name does not match with the UIViewController name.")
        }
        
        // Set the generated view to UIViewController root view
        view = nibView
    }
}
