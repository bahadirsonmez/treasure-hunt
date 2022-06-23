//
//  LocationPermissionViewController.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 21.06.2022.
//

import UIKit

class LocationPermissionViewController: BaseViewController {
    @IBOutlet private weak var permissionLabel: UILabel!
    @IBOutlet private weak var permissionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationNotifications()
    }
    
    private func configureLocationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidAuthorized(_:)), name: .locationAuthorizationDidAllowed, object: nil)
    }
    
    @objc
    private func locationDidAuthorized(_ notification: NSNotification) {
        pushTabBarController()
    }
    
    @IBAction func permissionButtonTapped(_ sender: UIButton) {
        guard LocationManager.shared.location() != nil else {
            if !LocationManager.shared.isLocationDenied() {
                LocationManager.shared.askForLocationServices()
            } else {
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            }
            return
        }
    }
    
    private func pushTabBarController() {
        let tabbarController = TabBarController()
        navigationController?.setViewControllers([tabbarController], animated: true)
    }
}
