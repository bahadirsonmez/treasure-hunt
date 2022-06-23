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
    private var radius: CLLocationDistance = 500
    
    private var annotation: MKPointAnnotation? {
        didSet {
            guard let annotation = annotation else { return }
            mapView.addAnnotation(annotation)
        }
    }
    private let viewModel: HuntViewModel
    private var estimatedDistance: CLLocationDistance = 0
    
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
        mapView.centerToLocation(location, regionRadius: radius)
    }
    
    private func configureButton() {
        startButton.backgroundColor = .greenButtonColor
        startButton.layer.cornerRadius = 8.0
        startButton.setTitle("Start Hunt", for: .normal)
        startButton.setTitleColor(.systemBackground, for: .normal)
        startButton.titleLabel?.font = .preferredFont(forTextStyle: .title1)
    }
    
    @IBAction private func startButtonTapped(_ sender: UIButton) {
        let huntModel = HuntModel(estimatedDistance: estimatedDistance)
        let viewModel = CurrentHuntDetailViewModel(model: huntModel)
        let contentVC = CurrentHuntDetailViewController(viewModel: viewModel)
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
    
    // MARK: - Helpers
    
    private func generateRandomPointAnnotation() {
        removeAnnotation(annotation)
        let annotation = MKPointAnnotation()
        annotation.coordinate = LocationManager.shared.generateRandomCoordinates(min: 50, max: 300)
        self.annotation = annotation
        self.getDirections(to: annotation)
    }
    
    private func removeAnnotation(_ annotation: MKPointAnnotation?) {
        if let annotation = annotation {
            mapView.removeAnnotation(annotation)
        }
    }
    
    private func getDirections(to annotation: MKPointAnnotation?) {
        if let annotation = annotation {
            mapView.getDirections(to: annotation, completion: { [weak self] distance in
                self?.estimatedDistance = distance ?? 0
            })
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
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annoId")
//        if annotation.title == "Annotation Title" {
//            annotationView.image = UIImage(systemName: "xmark")
//            return annotationView
//        }
//        return nil
//    }
}

extension HuntViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        CurrentHuntDetailLayout()
    }
    
    func floatingPanelDidEndRemove(_ vc: FloatingPanelController) {
        // Removal
    }
}
