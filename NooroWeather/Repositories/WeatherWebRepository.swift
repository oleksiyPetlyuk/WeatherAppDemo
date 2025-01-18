//
//  WeatherWebRepository.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import Foundation

protocol WeatherWebRepository: WebRepository {
    func searchCities(by query: String) async throws -> [City]
    func fetchCurrentWeather(for city: City) async throws -> Weather
}

struct DefaultWeatherWebRepository: WeatherWebRepository {
    let session: URLSession
    let baseURL: String

    func searchCities(by query: String) async throws -> [City] {
        try await call(endpoint: API.searchCities(query))
    }

    func fetchCurrentWeather(for city: City) async throws -> Weather {
        try await call(endpoint: API.fetchCurrentWeather(city.id))
    }
}

extension DefaultWeatherWebRepository {
    enum API {
        case searchCities(String)
        case fetchCurrentWeather(City.ID)
    }
}

extension DefaultWeatherWebRepository.API: APICall {
    var path: String {
        var path = ""

        switch self {
        case let .searchCities(query):
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

            path = "/search.json?q=\(encodedQuery ?? query)"
        case let .fetchCurrentWeather(id):
            guard let encodedQuery = "id:\(id)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                break
            }

            path = "/current.json?q=\(encodedQuery)"
        }

        return path.appending("&key=\(AppEnvironment.apiKey)")
    }

    var method: HTTPMethod {
        switch self {
        case .searchCities, .fetchCurrentWeather:
            return .get
        }
    }

    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }

    func body() throws -> Data? {
        return nil
    }
}
