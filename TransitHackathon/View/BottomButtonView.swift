//
//  BottomButtonView.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 04.11.24.
//

import SwiftUI

struct BottomButtonView: View {
    var imageName:String
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 45, height: 45)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundColor(.yellow)
                .offset(y:-2)
        }
    }
}

#Preview {
    BottomButtonView(imageName:"exclamationmark.triangle.fill")
}
