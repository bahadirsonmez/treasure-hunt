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
    
    func getDirections(to annotation: MKPointAnnotation, completion: @escaping (_ estimatedDistance: CLLocationDistance?) -> Void){
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
        request.requestsAlternateRoutes = false
        var estimatedDistance: CLLocationDistance = 0.0
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let overlays = self.overlays
                self.removeOverlays(overlays)
                for route in response!.routes {
                    estimatedDistance += route.distance
                    self.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
                }
                completion(estimatedDistance)
            }
        }
    }
}
