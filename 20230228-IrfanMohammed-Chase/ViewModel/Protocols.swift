//
//  Protocols.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import UIKit

// View Model Protocols
protocol ViewModelable {
    func getCurrentCityResult(lat: Double, lon: Double, completion:@escaping WeatherResponse)
    func addCitiesResults(city: String, completion:@escaping AddCityWeatherResponse)
}

// Add cities protocol used from search bar
protocol AddCitiesProviding: AnyObject {
    func getCityData(_ city: String)
}

//@objc protocol InitialViewControlling where Self: UIViewController {
//    func showErrorAlert()
//}

typealias WeatherResponse = (WeatherResult<ListModel>) -> Void
typealias AddCityWeatherResponse = (WeatherResult<AddCityModel>) -> Void


/// Constant
enum ViewConstants: String {
    case currentCell, hourCell, cityCell
    case refresh = "Pull to refresh"
    case hourForecast = "Todays's 3 Hour Forecast"
    case cityList = "List of cities"
    case title = "Weather App"
    case cityWeatherTitle = "City Weather"
    case main = "Main"
    case detailIdentifier = "DetailVC"
    case searchIdentifier = "SearchVC"
}

// Weather Detail data struct to use City weather service call
struct DetailWeatherData {
    let lat: Double
    let lon: Double
    var city: String
    
    init(lat: Double, lon: Double, city: String) {
        self.lat = lat
        self.lon = lon
        self.city = city
    }
}


