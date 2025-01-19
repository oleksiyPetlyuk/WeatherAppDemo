//
//  SearchBar.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String

    let onSubmit: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.backgroundSecondary)
                .frame(height: 46)

            HStack {
                TextField(
                    "",
                    text: $searchText,
                    prompt: Text("Search Location").foregroundStyle(.labelSecondary)
                )
                .font(.poppins(.regular, 15))
                .foregroundStyle(.labelPrimary)
                .tint(.labelPrimary)
                .textFieldStyle(.plain)
                .submitLabel(.search)
                .onSubmit { onSubmit() }

                Spacer()

                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.labelSecondary)
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SearchBar(searchText: .constant(""), onSubmit: {})

    SearchBar(searchText: .constant("Chicago"), onSubmit: {})
}
