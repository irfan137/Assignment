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
    
    var data: ListModel? {
        didSet {
            weatherDetail.text = data?.list?[0].weather?[0].description.capitalized ?? ""
            let country = data?.city?.country ?? ""
            cityName.text = (data?.city?.name ?? "") + country
            iconImage.image = UIImage(named: data?.list?[0].weather?[0].icon ?? "01d")
            let temp = ClimateHelper().toCelsius(kelvin: data?.list?[0].main?.temp ?? 0.0)
            tempDetail.text = String(format: "%0.0f", temp) + "°C"
        }
    }
}
