//
//  Models.swift
//  Weather App
//
//  Created by David on 1/3/23.
//

import Foundation

struct MainWeather: Codable {
    
    var weather: [weatherModel]
    var main: mainModel
    var wind: windModel
    var name: String
}

struct WeatherModel: Codable {
    
    var main: String
    var description: String
    var icon: String
}

struct MainModel: Codable {
    
    var feels_like: Double
    var humidity: Int
}

struct WindModel: Codable {
    
    var speed: Double
}
