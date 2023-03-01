//
//  MainWeatherViewController+LocationManager.swift
//  20230228-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import CoreLocation

// MARK: Core Location
extension MainWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("determine")
        case .restricted, .denied:  print("restricted")
        case .authorizedAlways, .authorizedWhenInUse:
            getCurrentLocation()
        @unknown default: break
        }
    }
}
