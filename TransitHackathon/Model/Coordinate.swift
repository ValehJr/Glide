//
//  Coordinate.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 01.11.24.
//

import CoreLocation

struct Coordinate: Hashable {
    let latitude: Double
    let longitude: Double
    
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct CoordinatePoint: Hashable {
    let latitude: Double
    let longitude: Double
    let busNumber: String?
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
