//
//  BaseViewController.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 23.06.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidDenied(_:)), name: .locationAuthorizationDidDenied, object: nil)
    }
    
    @objc
    private func locationDidDenied(_ notification: NSNotification) {
        AlertHelper.showPermanentAlert("Location Alert", message: "We need to use your location to track your path.")
    }
    
}
