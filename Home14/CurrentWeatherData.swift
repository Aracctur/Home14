//
//  CurrentWeatherData.swift
//  Home14
//
//  Created by Maxim Chalikov on 28.12.2020.
//

import Foundation

struct CurrentWeatherData: Codable {
    let main: Main
}
struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
