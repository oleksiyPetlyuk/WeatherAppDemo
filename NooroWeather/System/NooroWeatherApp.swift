//
//  NooroWeatherApp.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import SwiftUI

@main
struct NooroWeatherApp: App {
    private let environment = AppEnvironment.bootstrap()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentView.ViewModel(container: environment.diContainer))
        }
    }
}
