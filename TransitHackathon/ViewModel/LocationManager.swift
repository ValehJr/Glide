//
//  LocationManager.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 01.11.24.
//

import SwiftUI
import MapKit
import CoreLocation


@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.4093, longitude: 49.8671), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    var isZoomedEnough:Bool = true
    
    var cameraPositionZoom = MKMapCamera()

    
    var locationManager: CLLocationManager?
    var userLocation: CLLocationCoordinate2D? {
        didSet {
            if let userLocation = userLocation {
                cameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
            }
        }
    }
    
    func updateZoomLevel() {
        let thresholdZoomLevel: Double = 1000
        isZoomedEnough = cameraPositionZoom.centerCoordinateDistance < thresholdZoomLevel
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.startUpdatingLocation() // Start updating the location
            checkLocationAuthorization() // Check authorization after starting updates
        } else {
            print("Turn the location services on")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted")
        case .denied:
            print("You have denied permission")
        case .authorizedAlways, .authorizedWhenInUse:
            if let userLocation = locationManager.location?.coordinate {
                self.userLocation = userLocation
            }
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Update the user's location
        userLocation = location.coordinate // Automatically updates the camera position through the observer
    }
    
}
