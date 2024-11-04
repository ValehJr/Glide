//
//  SearchFieldsView.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 03.11.24.
//

import SwiftUI

struct SearchFieldsView: View {
    @Binding var fromSearchQuery: String
    @Binding var toSearchQuery: String
    @Binding var isEditingFromField: Bool
    @Binding var isEditingToField: Bool
    let performSearch: (Bool) -> Void
    
    var body: some View {
        VStack {
            CustomTextField(text: $fromSearchQuery, placeholder: "Search for start point", isEditingChanged: { isEditing in
                isEditingFromField = isEditing
            }, onCommit: {
                performSearch(true)
            })
            .padding(.top, 4)
            
            if !fromSearchQuery.isEmpty || isEditingFromField {
                CustomTextField(text: $toSearchQuery, placeholder: "Search for destination point", isEditingChanged: { isEditing in
                    isEditingToField = isEditing
                }, onCommit: {
                    performSearch(false)
                })
            }
            Spacer()
        }
        .padding()
    }
}
#Preview {
    @Previewable @State var fromSearchQuery = "Location"
    @Previewable @State var toSearchQuery = "Location"
    @Previewable @State var isEditingFromField = true
    @Previewable @State var isEditingToField = true
    
    SearchFieldsView(fromSearchQuery: $fromSearchQuery, toSearchQuery: $toSearchQuery, isEditingFromField: $isEditingFromField, isEditingToField: $isEditingToField, performSearch: { isFromSearch in
        print("Perform search called. isFromSearch: \(isFromSearch)")
    })
}
