//
//  Extensions.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import UIKit
import CoreLocation

extension Date {
    static func getHourFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        // Set time zone by user location
        let getTiemZone = TimeZone.current.identifier
        dateFormatter.timeZone = TimeZone(abbreviation: getTiemZone)
        return  dateFormatter.string(from: date)
    }
}

class ClimateHelper {
    internal let kKelvinZeroInCelsius = 273.15
    internal let kFahrenheitZeroInKelvin = -459.67
    
    func toCelsius(kelvin: Double) -> Double {
        return kelvin - kKelvinZeroInCelsius
    }
    
    func toFahrenheit(celsius: Double) -> Double {
        return celsius * 9 / 5 + 32
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}


