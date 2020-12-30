//
//  ForecastWeather.swift
//  Home14
//
//  Created by Maxim Chalikov on 28.12.2020.
//

import Foundation

class ForecastWeather {
    
   
    var dtString:String
    var temp: Double
    var tempString: String {
            return String(format: "%.0f", temp) + "℃"
    }
    var description: String
    
    init?(data: NSDictionary) {
        guard let main = data["main"] as? [String:Double],
              let temp = main["temp"],
              let dtString = data["dt_txt"] as? String,
              let weather = data["weather"] as? [NSDictionary],
              let description = weather[0]["description"] as? String
        else {return nil}
   
        self.dtString = dtString
        self.temp = temp
        self.description = description
    }
    required init? (dtString: String, temp: Double, description: String) {
        self.dtString = dtString
        self.temp = temp
        self.description = description
    }
}

