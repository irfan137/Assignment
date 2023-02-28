//
//  HourlyTableViewCell.swift
//  20230328-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var weatherDetails: UILabel!
    
    var data: ListDetail? {
        didSet {
            let date = Date(timeIntervalSince1970: Double(data?.dt ?? 0))
            let hourString = Date.getHourFrom(date: date)
            hourLabel.text = hourString
            iconImageView.image = UIImage(named: data?.weather?[0].icon ?? "01d")
            let temp = ClimateHelper().toCelsius(kelvin: data?.main?.temp ?? 0.0)
            tempLabel.text = String(format: "%0.0f", temp) + "°C"
            
            weatherDetails.text = data?.weather?[0].description.capitalized ?? ""
            
        }
    }
}
