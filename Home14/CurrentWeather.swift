//
//  CurrentWeather.swift
//  Home14
//
//  Created by Maxim Chalikov on 28.12.2020.
//

import Foundation


class CurrentWeather {
    let temp: Double
    var tempString: String {
            return String(format: "%.0f", temp) + "℃"
    }
    let feelsLike : Double
    var feelsLikeString: String {
                return String(format: "%.0f", feelsLike) + "℃"
    }
    let tempMin: Double
    var tempMinString: String {
            return String(format: "%.0f", tempMin) + "℃"
    }
    let tempMax: Double
    var tempMaxString: String {
            return String(format: "%.0f", tempMax) + "℃"
    }
    
    init?(currentWeatherData: CurrentWeatherData){

        self.temp = currentWeatherData.main.temp
        self.feelsLike = currentWeatherData.main.feelsLike
        self.tempMin = currentWeatherData.main.tempMin
        self.tempMax = currentWeatherData.main.tempMax
    }
}

