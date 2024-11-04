//
//  CustomTextField.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 02.11.24.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    @State var placeholder: String
    var isEditingChanged: ((Bool) -> Void)?
    var onCommit: (() -> Void)?

    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text, onEditingChanged: { isEditing in
                isEditingChanged?(isEditing)
                if !isEditing && text.isEmpty {
                    onCommit?()
                }
            }, onCommit: {
                onCommit?()
            })
            .foregroundColor(Color.white)
            .padding(.horizontal, 18)
            .frame(height: 48)
            .background(Color(.customGray))
            .cornerRadius(28)
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.customLightGray)
                    .padding(.horizontal, 18)
            }

        }
        .frame(width: 280, height: 48)
        .padding(.trailing, 30)
    }
}

#Preview {
    @Previewable @State var stringS = ""
    CustomTextField(text: $stringS,placeholder: "Search")
}
