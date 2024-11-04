//
//  Coordinates.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 01.11.24.
//

import CoreLocation
import SwiftUI

let rowSpacing:CGFloat = 10
var gridLayout: [GridItem] {
   return Array(repeating: GridItem(.flexible(),spacing: rowSpacing), count: 2)
}
