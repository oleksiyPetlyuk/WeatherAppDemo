//
//  WeatherDBRepository.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/19/25.
//

import Foundation

protocol WeatherDBRepository {
    func fetchSavedCity() -> City?
    func saveCity(_ city: City)
}

struct DefaultWeatherDBRepository: WeatherDBRepository {
    private let persistentStore: PersistentStore

    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }

    func fetchSavedCity() -> City? {
        persistentStore.load(City.self, forKey: PersistenceKey.savedCity.rawValue)
    }

    func saveCity(_ city: City) {
        persistentStore.save(
            City(id: city.id, name: city.name, currentWeather: nil),
            forKey: PersistenceKey.savedCity.rawValue
        )
    }
}

extension DefaultWeatherDBRepository {
    enum PersistenceKey: String {
        case savedCity
    }
}
