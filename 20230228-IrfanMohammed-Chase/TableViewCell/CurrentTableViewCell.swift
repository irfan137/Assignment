//
//  CurrentTableViewCell.swift
//  20230328-IrfanMohammed-Chase
//
//  Created by Irfan Mohammed on 2/28/23.
//

import UIKit

class CurrentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempDetail: UILabel!
    @IBOutlet weak var weatherDetail: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
            
    var data: WeatherModel? {
        didSet {
            if let tempTxt = data?.current.temp {
                tempDetail.text = "\(Int(tempTxt.rounded()))°F"
                
            }
            iconImage.image = UIImage(named: data?.current.weather[0].icon ?? "01d")
            //cityName.text  = data?.current.weather[0].main
            weatherDetail.text = data?.current.weather[0].description.capitalized
        }
    }
}
