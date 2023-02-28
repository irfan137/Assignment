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
    var data: Hourly? {
        didSet {
            let date = Date(timeIntervalSince1970: Double(data?.dt ?? 0))
            let hourString = Date.getHourFrom(date: date)
            hourLabel.text = hourString
            iconImageView.image = UIImage(named: data?.weather[0].icon ?? "01d")
            tempLabel.text = "\(Int(data?.temp.rounded() ?? 0.0))°F"
        }
    }
}
