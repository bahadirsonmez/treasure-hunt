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
        generateAnnoLoc()
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
