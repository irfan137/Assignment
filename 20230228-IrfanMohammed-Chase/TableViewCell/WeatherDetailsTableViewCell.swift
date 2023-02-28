//
//  WeatherDetailsTableViewCell.swift
//  20230328-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import UIKit

class WeatherDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var cityDetail: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tempType: UILabel!
    @IBOutlet weak var tempDetail: UILabel!
    
    var data: Location? {
        didSet {
            let city = data?.name ?? ""
            let country = data?.country ?? ""
            let cityDetails = city + ", " + country
            cityDetail.text = cityDetails
            tempType.text = data?.tempType
            let temp = ClimateHelper().toCelsius(kelvin: data?.temp ?? 0.0)
            tempDetail.text = String(format: "%0.0f", temp) + "°"
            
            let date = Date(timeIntervalSince1970: data?.currentDate ?? 0)
            dateLbl.text = Date.getHourFrom(date: date)
        }
    }
}
