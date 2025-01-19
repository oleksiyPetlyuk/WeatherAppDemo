//
//  DIContainer.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/19/25.
//

import Foundation

struct DIContainer {
    let services: Services
}

extension DIContainer {
    struct WebRepositories {
        let weatherRepository: WeatherWebRepository
    }

    struct DBRepositories {
        let weatherRepository: WeatherDBRepository
    }

    struct Services {
        let weatherService: WeatherService

        static var stub: Self {
            .init(weatherService: StubWeatherService())
        }
    }

    struct PersistentStores {
        let store: PersistentStore
    }
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(services: .stub)
    }
}
#endif
