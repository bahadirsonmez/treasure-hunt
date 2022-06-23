//
//  LocationManager.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 17.06.2022.
//

import UIKit
import CoreLocation

extension NSNotification.Name {
    static let locationAuthorizationDidAllowed = Notification.Name(rawValue: "locationAuthorizationDidAllowed")
    static let locationAuthorizationDidDenied = Notification.Name(rawValue: "locationAuthorizationDidDenied")
    
    static let orderDelivered = Notification.Name(rawValue: "orderDelivered")
    static let addressDidChanged = Notification.Name(rawValue: "addressDidChanged")
}

typealias LocationUpdateHandler = () -> Void
typealias DidChangeAuthorizationHandler = () -> Void

protocol LocationManagerDelegate: AnyObject {
    func locationPermissionSuccess()
}

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    fileprivate let locationManager = CLLocationManager()
    var locationUpdateHandler: LocationUpdateHandler?
    weak var delegate: LocationManagerDelegate?
    private var lastLocations = [CLLocation]()
    
    var currentAuthorizationState: CLAuthorizationStatus {
        get {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    var previousState: CLAuthorizationStatus?
    
    var didChangeAuthorization : DidChangeAuthorizationHandler?
    
    override init() {
        super.init()
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func askForLocationServices() {
        if !CLLocationManager.locationServicesEnabled() {
            NotificationCenter.default.post(name: .locationAuthorizationDidDenied, object: nil)
        }
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func isLocationDenied() -> Bool {
        return CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .restricted
    }
    
    func isNotDetermined() -> Bool {
        return CLLocationManager.authorizationStatus() == .notDetermined
    }
        
    func stopLocationServices() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func location() -> CLLocation? {
        if let location = self.locationManager.location, CLLocationCoordinate2DIsValid(location.coordinate) {
            self.lastLocations.append(location)
            return location
        }
        return nil
    }
    
    func isAuthorized() -> Bool {
        let status =  CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            return true
        }
        return false
    }
            
    private func sendLocationIfValid(_ location: CLLocation?) {
        if let location = self.locationManager.location,
           CLLocationCoordinate2DIsValid(location.coordinate) {
            DispatchQueue.main.async(execute: {
                self.locationUpdateHandler?()
            })
        }
    }
    
    func clearLocationsArray() {
        lastLocations.removeAll()
    }
    
    func calculateDistanceBetweenLastTwoLocations() -> CLLocationDistance? {
        guard lastLocations.count > 1 else { return nil }
        let lastIndex = lastLocations.count - 1
        return lastLocations[lastIndex].distance(from: lastLocations[lastIndex-1])
    }
    
    func generateRandomCoordinates(min: UInt32, max: UInt32) -> CLLocationCoordinate2D {
        let currentLong = location()?.coordinate.longitude ?? 0
        let currentLat = location()?.coordinate.latitude ?? 0
        
        //1 KiloMeter = 0.00900900900901° So, 1 Meter = 0.00900900900901 / 1000
        let meterCord = 0.00900900900901 / 1000
        
        //Generate random Meters between the maximum and minimum Meters
        let randomMeters = UInt(arc4random_uniform(max) + min)
        
        //then Generating Random numbers for different Methods
        let randomPM = arc4random_uniform(6)
        
        //Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
        let metersCordN = meterCord * Double(randomMeters)
        
        //here we generate the last Coordinates
        if randomPM == 0 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 1 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 2 {
            return CLLocationCoordinate2D(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
        }else if randomPM == 3 {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
        }else if randomPM == 4 {
            return CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - metersCordN)
        }else {
            return CLLocationCoordinate2D(latitude: currentLat - metersCordN, longitude: currentLong)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let previousState = self.previousState, previousState != currentAuthorizationState {
            didChangeAuthorization?()
        }
        
        previousState = currentAuthorizationState
        
        delegate?.locationPermissionSuccess()
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            NotificationCenter.default.post(name: .locationAuthorizationDidAllowed, object: nil)
            
            return
        }
        if isLocationDenied() {
            NotificationCenter.default.post(name: .locationAuthorizationDidDenied, object: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.sendLocationIfValid(locations.last)
        print("Accuracy: %@", manager.location!.horizontalAccuracy)
    }
}

extension CLLocationCoordinate2D {
    
    var latitudeStringValue: String{
        return String(self.latitude)
    }
    
    var longitudeStringValue: String{
        return String(self.longitude)
    }
    
    var latitudeNumberValue: NSNumber{
        return NSNumber(value: latitude)
    }
    
    var longitudeNumberValue: NSNumber{
        return NSNumber(value: longitude)
    }
}
