//
//  ViewModel.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import Foundation
import UIKit

class ViewModel: ViewModelable {
    var status: Int?
   // weak var controller: InitialViewControlling?
    
    private func getWeatherData<T: Decodable>(urlString: String, completion: @escaping (WeatherResult<T>) -> Void) {
        
        guard let updatedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: updatedUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            // perhaps check err
            // also perhaps check response status 200 OK
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    // For Unit testing
                    self.status = 200
                    completion(.success(SuccessResponse(modelObject: obj, statusCode: 200)))
                }
            } catch let jsonErr {
                self.status = 500
                completion(.failure(ErrorResponse(error: jsonErr, statusCode: 500, networkError: true)))
            }
        }.resume()
    }
}

extension ViewModel {
    
    /// Get current city weather data One Weather API
    /// - Parameters:
    ///   - lat: Latitude
    ///   - lon: Longitude
    ///   - completion: WeatherResponse
    func getCurrentCityResult(lat: Double, lon: Double, completion:@escaping WeatherResponse) {
        getWeatherData(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=imperial&appid=10ed99eecb01537fb30cee9c9cd7b877") { (result: WeatherResult<WeatherModel>) in
            switch result {
            case .success(let response):
                completion(.success(SuccessResponse(modelObject: response.modelObject, statusCode: 200)))
            case .failure(let response):
                completion(.failure(ErrorResponse(error: response.error, statusCode: 500, networkError: true)))
            }
        }
    }
    
    /// Get city weather data from One Weather API
    /// - Parameters:
    ///   - city: String
    ///   - completion: AddCityWeatherResponse
    func addCitiesResults(city: String, completion:@escaping AddCityWeatherResponse) {
        getWeatherData(urlString: "https://api.openweathermap.org/data/2.5/weather?APPID=10ed99eecb01537fb30cee9c9cd7b877&q=\(city)") { (result: WeatherResult<AddCityModel>) in
            switch result {
            case .success(let response):
                completion(.success(SuccessResponse(modelObject: response.modelObject, statusCode: 200)))
            case .failure(let response):
                completion(.failure(ErrorResponse(error: response.error, statusCode: 500, networkError: true)))
            }
        }
    }
}

