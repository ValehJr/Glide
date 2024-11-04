//
//  ObstacleView.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 02.11.24.
//

import SwiftUI

struct ObstaclesGridView: View {
    var obstacleSelected: (ObstaclesEnum) -> Void // Closure to handle selection
    
    var body: some View {
        LazyVGrid(columns: gridLayout) {
            ForEach(ObstaclesEnum.allCases, id: \.self) { obstacle in
                ObstacleView(imageName: obstacle.imageName, alertName: obstacle.alertName) {
                    obstacleSelected(obstacle) // Call closure on selection
                }
                .padding()
            }
        }
        .padding()
        .background(.customGray)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
