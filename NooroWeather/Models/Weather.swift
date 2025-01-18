//
//  Weather.swift
//  NooroWeather
//
//  Created by Petlyuk, Oleksiy on 1/18/25.
//

import Foundation

struct Weather {
    let temperature: Measurement<UnitTemperature>
    let feelsLikeTemperature: Measurement<UnitTemperature>
    let condition: Condition
    let humidity: UInt8
    let uvIndex: Double

    enum CodingKeys: String, CodingKey {
        case current
    }

    enum WeatherCodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case feelsLikeTemperature = "feelslike_c"
        case condition
        case humidity
        case uvIndex = "uv"
    }

    init(
        temperature: Measurement<UnitTemperature>,
        feelsLikeTemperature: Measurement<UnitTemperature>,
        condition: Condition,
        humidity: UInt8,
        uvIndex: Double
    ) {
        self.temperature = temperature
        self.feelsLikeTemperature = feelsLikeTemperature
        self.condition = condition
        self.humidity = humidity
        self.uvIndex = uvIndex
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let weather = try container.nestedContainer(keyedBy: WeatherCodingKeys.self, forKey: .current)

        let temperature = try weather.decode(Double.self, forKey: .temperature)
        self.temperature = Measurement(value: temperature, unit: UnitTemperature.celsius)

        let feelsLikeTemperature = try weather.decode(Double.self, forKey: .feelsLikeTemperature)
        self.feelsLikeTemperature = Measurement(value: feelsLikeTemperature, unit: UnitTemperature.celsius)

        condition = try weather.decode(Condition.self, forKey: .condition)
        humidity = try weather.decode(UInt8.self, forKey: .humidity)
        uvIndex = try weather.decode(Double.self, forKey: .uvIndex)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var weather = container.nestedContainer(keyedBy: WeatherCodingKeys.self, forKey: .current)
        try weather.encode(temperature.converted(to: .celsius).value, forKey: .temperature)
        try weather.encode(feelsLikeTemperature.converted(to: .celsius).value, forKey: .feelsLikeTemperature)
        try weather.encode(condition, forKey: .condition)
        try weather.encode(humidity, forKey: .humidity)
        try weather.encode(uvIndex, forKey: .uvIndex)
    }
}

extension Weather {
    struct Condition {
        let text: String
        let iconUrl: URL

        enum CodingKeys: String, CodingKey {
            case text
            case iconUrl = "icon"
        }

        init(text: String, iconUrl: URL) {
            self.text = text
            self.iconUrl = iconUrl
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            text = try container.decode(String.self, forKey: .text)

            var iconUrl = try container.decode(String.self, forKey: .iconUrl)
            iconUrl = "https:\(iconUrl)"

            guard let url = URL(string: iconUrl) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Invalid URL format: \(iconUrl)"
                    )
                )
            }

            self.iconUrl = url
        }

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(text, forKey: .text)
            try container.encode(iconUrl.absoluteString.replacingOccurrences(of: "https:", with: ""), forKey: .iconUrl)
        }
    }
}

extension Weather.Condition: Codable, Hashable {}
extension Weather: Codable, Hashable {}
