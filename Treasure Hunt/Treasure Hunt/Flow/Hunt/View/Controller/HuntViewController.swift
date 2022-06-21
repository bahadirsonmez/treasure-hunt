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
    private var fpc: FloatingPanelController!
    
    private var annotation: MKPointAnnotation?
    private let viewModel: HuntViewModel
    
    // MARK: - Initializers
    
    init(viewModel: HuntViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManager.shared.askForLocationServices()
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.generateRandomPointAnnotation()
        }
    }
        
    private func setup() {
        configureButton()
        configureLocationNotifications()
        configureMapView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.locationChanged = { [weak self] location in
            self?.centerToTheLocation(location)
        }
    }
    
    private func configureMapView() {
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.showsBuildings = false
        mapView.delegate = self
    }
    
    private func configureLocationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidAuthorized(_:)), name: .locationAuthorizationDidAllowed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidDenied(_:)), name: .locationAuthorizationDidDenied, object: nil)
    }
    
    @objc
    private func locationDidAuthorized(_ notification: NSNotification) {
        viewModel.currentLocation = LocationManager.shared.location()
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
        startButton.backgroundColor = .greenButtonColor
        startButton.layer.cornerRadius = 8.0
        startButton.setTitle("Start Hunt", for: .normal)
        startButton.setTitleColor(.systemBackground, for: .normal)
        startButton.titleLabel?.font = .preferredFont(forTextStyle: .title1)
    }
    
    @IBAction private func startButtonTapped(_ sender: UIButton) {
        let contentVC = CurrentHuntDetailViewController()
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.set(contentViewController: contentVC)
        fpc.surfaceView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        fpc.surfaceView.layer.cornerRadius = 20
        fpc.surfaceView.clipsToBounds = true
        fpc.contentMode = .static
        fpc.addPanel(toParent: self)
        fpc.hide()
        fpc.show(animated: true, completion: nil)
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
        self.annotation = annotation
//        self.getDirections()
    }
    
    private func generateRandomCoordinates(min: UInt32, max: UInt32)-> CLLocationCoordinate2D {
        let currentLong = viewModel.currentLocation?.coordinate.longitude ?? 0
        let currentLat = viewModel.currentLocation?.coordinate.latitude ?? 0
        
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

// MARK: - Helpers

extension HuntViewController {
    func getDirections(){
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation!.coordinate))
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let overlays = self.mapView.overlays
                self.mapView.removeOverlays(overlays)
                for route in response!.routes {
                    self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                }
            }
        }
    }
}

// MARK: - MKMapViewDelegate

extension HuntViewController: MKMapViewDelegate {
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay ) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemGreen
        renderer.lineWidth = 5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annoId")
        if annotation.title == "Annotation Title" {
            annotationView.image = UIImage(systemName: "xmark")
            return annotationView
        }
        return nil
    }
}

extension HuntViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        CurrentHuntDetailLayout()
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        // Removal
    }
}
