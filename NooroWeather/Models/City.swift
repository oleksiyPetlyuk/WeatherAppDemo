//
//  City.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import Foundation

struct City {
    let id: Int
    let name: String
    let currentWeather: Weather?
}

extension City: Codable, Hashable, Identifiable {}
