//
//  WeatherService.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import Foundation

protocol WeatherService {
    func fetchSavedCityWeather() async throws -> City?
    func searchCities(by query: String) async throws -> [City]
    func saveCity(_ city: City)
}

struct DefaultWeatherService: WeatherService {
    let webRepository: WeatherWebRepository
    let dbRepository: WeatherDBRepository

    func fetchSavedCityWeather() async throws -> City? {
        guard let savedCity = dbRepository.fetchSavedCity() else { return nil }

        let currentWeather = try await webRepository.fetchCurrentWeather(for: savedCity)

        return City(id: savedCity.id, name: savedCity.name, currentWeather: currentWeather)
    }

    func searchCities(by query: String) async throws -> [City] {
        var cities = try await webRepository.searchCities(by: query)

        cities = try await withThrowingTaskGroup(of: (City, Weather).self) { group in
            for city in cities {
                group.addTask {
                    let weather = try await webRepository.fetchCurrentWeather(for: city)

                    return (city, weather)
                }
            }

            var cities: [City] = []
            for try await (city, weather) in group {
                cities.append(City(id: city.id, name: city.name, currentWeather: weather))
            }

            return cities
        }

        return cities
    }

    func saveCity(_ city: City) {
        dbRepository.saveCity(city)
    }
}

struct StubWeatherService: WeatherService {
    func fetchSavedCityWeather() async throws -> City? {
        return nil
    }

    func searchCities(by query: String) async throws -> [City] {
        return []
    }

    func saveCity(_ city: City) {
        //
    }
}
