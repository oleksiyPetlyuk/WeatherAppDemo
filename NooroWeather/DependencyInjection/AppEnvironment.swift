//
//  AppEnvironment.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/19/25.
//

import Foundation

struct AppEnvironment {
    let diContainer: DIContainer
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let session = configuredURLSession()
        let persistentStores = configuredPersistentStores()
        let webRepositories = configuredWebRepositories(session: session)
        let dbRepositories = configuredDBRepositories(persistentStore: persistentStores.store)
        let services = configuredServices(
            webRepository: webRepositories.weatherRepository,
            dbRepository: dbRepositories.weatherRepository
        )
        let diContainer = DIContainer(services: services)

        return AppEnvironment(diContainer: diContainer)
    }

    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared

        return URLSession(configuration: configuration)
    }

    private static func configuredPersistentStores() -> DIContainer.PersistentStores {
        let store = UserDefaultsPersistentStore(defaults: .standard)

        return .init(store: store)
    }

    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let weather = DefaultWeatherWebRepository(session: session, baseURL: "https://api.weatherapi.com/v1")

        return .init(weatherRepository: weather)
    }

    private static func configuredDBRepositories(persistentStore: PersistentStore) -> DIContainer.DBRepositories {
        let weather = DefaultWeatherDBRepository(persistentStore: persistentStore)

        return .init(weatherRepository: weather)
    }

    private static func configuredServices(
        webRepository: WeatherWebRepository,
        dbRepository: WeatherDBRepository
    ) -> DIContainer.Services {
        let weather = DefaultWeatherService(webRepository: webRepository, dbRepository: dbRepository)

        return .init(weatherService: weather)
    }
}

extension AppEnvironment {
    enum Keys {
        static let apiKey: String = "API_KEY"
    }

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }

        return dict
    }()

    static let apiKey: String = {
        guard let apiKeyString = infoDictionary[Keys.apiKey] as? String else {
            fatalError("API Key not found in plist")
        }

        return apiKeyString
    }()
}
