//
//  ContactUsViewController.swift
//  SwiftCart
//
//  Created by Israa on 09/06/2024.
//

import UIKit
import MapKit

class ContactUsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.handleLocation()
    }
    
    
    @IBAction func callBtn(_ sender: Any) {
        let phoneNumber = "+201551552939"
        if let phoneURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                Utils.showAlert(title: "Error", message: "Your device cannot make phone calls.", preferredStyle: .alert, from: self)
            }
        } else {
            Utils.showAlert(title: "Error", message: "Invalid phone number URL.", preferredStyle: .alert, from: self)
        }
    }
    
    func handleLocation() {
        let centerCoordinate = CLLocationCoordinate2D(latitude:  29.9611, longitude: 30.9296)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        annotation.title = "SwiftCart"
        mapView.addAnnotation(annotation)
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
    }
    @IBAction func backBtn(_ sender: Any) {
        coordinator?.finish()
    }


}
