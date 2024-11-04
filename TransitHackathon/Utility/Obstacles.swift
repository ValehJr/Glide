//
//  Obstacles.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 02.11.24.
//


import Foundation
import CoreLocation

struct Obstacle :Identifiable{
    var id = UUID()
    var type: ObstaclesEnum
    var coordinate: CLLocationCoordinate2D
}

enum ObstaclesEnum: String, CaseIterable {
    case closedRoad = "ClosedRoad"
    case inaccessibleSidewalk = "InaccessibleSidewalk"
    case openHatch = "OpenHatch"
    case insufficientElevator = "InsufficientElevator"
    case narrowPathway = "NarrowRoad"
    case slipperySidewalk = "SlipperySidewalk"
    
    var imageName: String {
        return rawValue
    }
    
    var alertName: String {
        return rawValue.splitCamelCase()
    }
}

extension String {
    // This function splits a camel case string into words
    func splitCamelCase() -> String {
        let regex = try! NSRegularExpression(pattern: "([a-z])([A-Z])", options: [])
        let range = NSRange(location: 0, length: self.count)
        let modifiedString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1 $2")
        return modifiedString.replacingOccurrences(of: "_", with: " ")
    }
}
