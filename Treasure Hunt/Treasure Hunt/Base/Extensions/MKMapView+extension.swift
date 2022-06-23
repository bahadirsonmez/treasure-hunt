//
//  MKMapView+extension.swift
//  Treasure Hunt
//
//  Created by Bahadır Sönmez on 12.06.2022.
//

import MapKit

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 500) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
    func getDirections(to annotation: MKPointAnnotation){
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let overlays = self.overlays
                self.removeOverlays(overlays)
                for route in response!.routes {
                    self.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                }
            }
        }
    }
}
