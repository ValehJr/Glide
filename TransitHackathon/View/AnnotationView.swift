//
//  AnnotationView.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 04.11.24.
//

import SwiftUI
import CoreLocation
import MapKit

struct AnnotationView: View {
    var imageName:String
    
    var body: some View {
        Image(imageName)
                       .resizable()
                       .scaledToFit()
                       .fontWeight(.bold)
                       .frame(width: 30, height: 30)
    }
}

#Preview {
    AnnotationView(imageName: "startPointPin")
}
