//
//  OneWeatherModel.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

/// City Model
struct AddCityModel: Codable {
    var coord: CityCoordinates?
    var weather: [Weather]
    var name: String?
    let dt: Int
    let sys: SystemDetails
    let main: Main
}

struct SystemDetails: Codable {
    let country: String
}

struct CityCoordinates: Codable {
    let lat: Double
    let lon: Double
}

struct Main: Codable {
    let temp: Double
}

/// Weather Model
struct WeatherModel: Codable {
let lat: Double
let lon: Double
let timezone: String?
let current: Current
var hourly: [Hourly]
}

struct Current: Codable {
let dt: Int
let sunrise: Int
let sunset: Int
let temp: Double
let feels_like: Double
let pressure: Int
let humidity: Int
let dew_point: Double
let uvi: Double
let clouds: Int
let wind_speed: Double
let wind_deg: Int
var weather: [Weather]
}

struct Weather: Codable {
let id: Int
let main: String
let description: String
let icon: String
}

struct Hourly: Codable {
let dt: Int
let temp: Double
let feels_like: Double
let pressure: Int
let humidity: Int
let dew_point: Double
let clouds: Int
let wind_speed: Double
let wind_deg: Int
let weather: [Weather]
}

