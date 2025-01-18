//
//  PersistentStore.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/19/25.
//

import Foundation

protocol PersistentStore {
    func save<T: Codable>(_ value: T, forKey key: String)
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?
}

struct UserDefaultsPersistentStore: PersistentStore {
    private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    func save<T: Codable>(_ value: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(value) {
            defaults.set(data, forKey: key)
        }
    }

    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }

        return try? JSONDecoder().decode(T.self, from: data)
    }
}
