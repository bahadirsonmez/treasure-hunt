//
//  HuntViewModel.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 21.06.2022.
//

import Foundation
import CoreLocation

class HuntViewModel: NSObject {
    var currentLocation: CLLocation? {
        didSet {
            locationChanged?(currentLocation)
        }
    }
    
    var locationChanged: ((_ location: CLLocation?) -> Void)?
    
    override init() {
        super.init()
        bindLocationManager()
    }
    
    private func bindLocationManager() {
        LocationManager.shared.locationUpdateHandler = { [weak self] in
            self?.currentLocation = LocationManager.shared.location()
        }
    }

}
