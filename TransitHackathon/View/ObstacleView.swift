//
//  ObstacleView.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 02.11.24.
//

import SwiftUI

struct ObstacleView: View {
    var imageName: String
    var alertName: String
    var onSelect: () -> Void // Closure to handle selection

    var body: some View {
        Button(action: {
            onSelect() // Call closure when the button is tapped
        }) {
            VStack {
                ZStack {
                    Image(systemName: "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 82)
                        .foregroundStyle(.white)
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48)
                        .foregroundStyle(.red)
                }
                Text(alertName)
                    .fontWeight(.medium)
                    .font(.headline)
                    .foregroundStyle(.red)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }
}


#Preview {
    ObstacleView(imageName: "SlipperySidewalk", alertName: "Slippery Sidewalk") {
        print("Tapped")
    }
}
