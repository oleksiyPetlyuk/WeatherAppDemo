//
//  HomeViewModel.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import Foundation
import SwiftUI

protocol HomeViewModel {
    var state: HomeView.HomeState { get }
    var searchText: String { get set }

    func fetchSavedCityWeather() async
    func searchCities() async
    func saveCity(_ city: City) async
}

extension HomeView {
    @Observable
    class ViewModel: HomeViewModel {
        @ObservationIgnored
        private let weatherService: WeatherService

        init(weatherService: WeatherService, state: HomeView.HomeState = .empty) {
            self.weatherService = weatherService
            self.state = state
        }

        private(set) var state: HomeView.HomeState = .empty

        var searchText = ""

        func fetchSavedCityWeather() async {
            do {
                state = .loading

                guard let city = try await weatherService.fetchSavedCityWeather() else {
                    state = .empty

                    return
                }

                state = .loaded(city)
            } catch {
                state = .error(error)
            }
        }

        func searchCities() async {
            do {
                guard searchText.count > 2 else {
                    if case .loaded = state { return }

                    await fetchSavedCityWeather()

                    return
                }

                state = .loading
                let results = try await weatherService.searchCities(by: searchText)
                state = .searchResults(results)
            } catch {
                state = .error(error)
            }
        }

        func saveCity(_ city: City) async {
            state = .loading
            weatherService.saveCity(city)
            searchText = ""
            await fetchSavedCityWeather()
        }
    }
}

extension HomeView {
    enum HomeState {
        case none
        case loading
        case empty
        case loaded(City)
        case searchResults([City])
        case error(Error)
    }
}
