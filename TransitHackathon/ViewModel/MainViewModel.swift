//
//  MainViewModel.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 02.11.24.
//

import SwiftUI
import MapKit
import Foundation

@Observable
class MainViewModel {
    var locationManager = LocationManager()
    var obstacles: [Obstacle] = []
    var fromSearchQuery: String = ""
    var toSearchQuery: String = ""
    var searchResults: [MKMapItem] = []
    var beginCoordinate: CLLocationCoordinate2D?
    var destCoordinate: CLLocationCoordinate2D?
    var coordinatesC: [CoordinatePoint] = []
    var startPointAnnotation: MKPointAnnotation?
    var destinationPointAnnotation: MKPointAnnotation?
    var isZoomedEnough: Bool = false
    var isEditingToField:Bool = false
    var isEditingFromField: Bool = false
    var isShowingDestination: Bool = false
    var isShowingAlert: Bool = false
    var isShowingAlarm:Bool = false

    func performSearch(isFromSearch: Bool) {
        let query = isFromSearch ? fromSearchQuery : toSearchQuery
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for location: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.searchResults = response.mapItems
            
            if let firstResult = self.searchResults.first {
                let coordinate = firstResult.placemark.coordinate
                if isFromSearch {
                    self.beginCoordinate = coordinate
                    self.startPointAnnotation = MKPointAnnotation()
                    self.startPointAnnotation?.coordinate = coordinate
                    self.startPointAnnotation?.title = "Start"
                } else {
                    self.destCoordinate = coordinate
                    self.destinationPointAnnotation = MKPointAnnotation()
                    self.destinationPointAnnotation?.coordinate = coordinate
                    self.destinationPointAnnotation?.title = "Destination"
                }
                self.locationManager.cameraPosition = .region(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }
        }
    }

    func sendRouteRequest() {
        guard let begin = beginCoordinate, let dest = destCoordinate else {
            print("Coordinates not set")
            return
        }
        
        let url = URL(string: "http://172.20.10.2:8080/route")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "begin": ["lat": String(format: "%.14f", begin.latitude), "long": String(format: "%.14f", begin.longitude)],
            "dest": ["lat": String(format: "%.14f", dest.latitude), "long": String(format: "%.14f", dest.longitude)]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making POST request: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data in response")
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    DispatchQueue.main.async {
                        self.coordinatesC = jsonArray.compactMap { coordDict in
                            if let coord = coordDict["coord"] as? [Double] {
                                let busNumber = coordDict["bus_number"] as? String
                                return CoordinatePoint(latitude: coord[0], longitude: coord[1], busNumber: busNumber)
                            }
                            return nil
                        }
                        self.updateCameraRegion()
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func updateCameraRegion() {
        guard !coordinatesC.isEmpty else { return }
        
        var minLat = coordinatesC[0].latitude
        var maxLat = coordinatesC[0].latitude
        var minLong = coordinatesC[0].longitude
        var maxLong = coordinatesC[0].longitude
        
        for point in coordinatesC {
            minLat = min(minLat, point.latitude)
            maxLat = max(maxLat, point.latitude)
            minLong = min(minLong, point.longitude)
            maxLong = max(maxLong, point.longitude)
        }
        
        let centerLatitude = (minLat + maxLat) / 2
        let centerLongitude = (minLong + maxLong) / 2
        let spanLatitude = maxLat - minLat + 0.02
        let spanLongitude = maxLong - minLong + 0.02
        let newRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude),
                                           span: MKCoordinateSpan(latitudeDelta: spanLatitude, longitudeDelta: spanLongitude))
        
        DispatchQueue.main.async {
            self.locationManager.cameraPosition = .region(newRegion)
        }
    }
    
    func colorForPolyline(from point: CoordinatePoint, to nextPoint: CoordinatePoint) -> Color {
        if point.busNumber == "2" && nextPoint.busNumber == "2" {
            return Color.green
        } else if point.busNumber == "88A" && nextPoint.busNumber == "88A" {
            return Color.red
        } else {
            return Color.blue
        }
    }
}
