//
//  HuntViewController.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 12.06.2022.
//

import UIKit
import MapKit

class HuntViewController: UIViewController {
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var startButton: UIButton!
    var fpc: FloatingPanelController!
    var currentLocation: CLLocation? {
        didSet {
            centerToTheLocation(currentLocation)
        }
    }
    
    private var isStarted: Bool = false
    //    {
    //        didSet {
    //            configureButton()
    //        }
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManager.shared.askForLocationServices()
        generateRandomPointAnnotation()
    }
    
    private func bindLocationManager() {
        LocationManager.shared.locationUpdateHandler = { [weak self] in
            self?.currentLocation = LocationManager.shared.location()
        }
    }
    
    private func setup() {
        configureButton()
        configureLocationNotifications()
        configureMapView()
        bindLocationManager()
    }
    
    private func configureMapView() {
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsBuildings = true
    }
    
    private func configureLocationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidAuthorized(_:)), name: .locationAuthorizationDidAllowed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidDenied(_:)), name: .locationAuthorizationDidDenied, object: nil)
    }
    
    @objc
    private func locationDidAuthorized(_ notification: NSNotification) {
        currentLocation = LocationManager.shared.location()
    }
    
    @objc
    private func locationDidDenied(_ notification: NSNotification) {
        print(notification.name)
    }
    
    private func centerToTheLocation(_ location: CLLocation?) {
        guard let location = location else { return }
        mapView.centerToLocation(location)
    }
    
    private func configureButton() {
        startButton.backgroundColor = isStarted ? .redButtonColor : .greenButtonColor
        startButton.layer.cornerRadius = 8.0
        startButton.setTitle(isStarted ? "Pause Hunt" : "Start Hunt", for: .normal)
        startButton.setTitleColor(.systemBackground, for: .normal)
        startButton.titleLabel?.font = .preferredFont(forTextStyle: .title1)
    }
    
    @IBAction private func startButtonTapped(_ sender: UIButton) {
        //        isStarted.toggle()
        let contentVC = CurrentHuntDetailViewController()
        let fpc = FloatingPanelController(delegate: contentVC)
        fpc.set(contentViewController: contentVC)
        fpc.surfaceView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        fpc.surfaceView.layer.cornerRadius = 20
        fpc.surfaceView.clipsToBounds = true
        fpc.contentMode = .static
        fpc.backdropView.dismissalTapGestureRecognizer.numberOfTapsRequired = 3
        self.present(fpc, animated: true, completion: nil)
    }
}

// MARK: - Random location

extension HuntViewController {
    private func generateRandomPointAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = generateRandomCoordinates(min: 50, max: 300)
        annotation.title = "Annotation Title"
        annotation.subtitle = "SubTitle"
        mapView.addAnnotation(annotation)
    }
    
    private func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
        //Get the Current Location's longitude and latitude
        let currentLong = currentLocation?.coordinate.longitude ?? 0
        let currentLat = currentLocation?.coordinate.latitude ?? 0
        
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
