//
//  ErrorView.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/19/25.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: (() -> Void)?

    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.poppins(.regular, 20))
                .foregroundStyle(.labelPrimary)
                .multilineTextAlignment(.center)

            Text(error.localizedDescription)
                .font(.poppins(.regular, 16))
                .foregroundStyle(.labelPrimary)
                .multilineTextAlignment(.center)

            if retryAction != nil {
                Button(action: retryAction!) {
                    Text("Retry")
                        .font(.poppins(.regular, 16))
                        .foregroundStyle(.labelPrimary)
                }
                .buttonStyle(.bordered)
                .padding(.top)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ErrorView(error: APIError.invalidStatusCode(statusCode: 400), retryAction: {})
}
