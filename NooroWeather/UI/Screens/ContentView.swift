//
//  ContentView.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private(set) var viewModel: ContentViewModel

    var body: some View {
        HomeView(viewModel: HomeView.ViewModel(weatherService: viewModel.container.services.weatherService))
    }
}

protocol ContentViewModel {
    var container: DIContainer { get }
}

extension ContentView {
    @Observable
    class ViewModel: ContentViewModel {
        let container: DIContainer

        init(container: DIContainer) {
            self.container = container
        }
    }
}

#Preview {
    ContentView(viewModel: ContentView.ViewModel(container: .preview))
}
