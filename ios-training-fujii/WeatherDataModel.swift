//
//  WeatherDataModel.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/12.
//

import Foundation
import UIKit

enum WeatherCondition: String, Decodable {
    case sunny
    case cloudy
    case rainy
    
    var weatherImage: UIImage {
        return UIImage(named: rawValue) ?? UIImage()
    }
    
    var tintColor: UIColor {
        switch self {
        case .sunny:
            return .red
        case .cloudy:
            return .gray
        case .rainy:
            return .blue
        }
    }
    
}

struct WeatherAPIRequest: Encodable {
    var area: String
    var date: Date
}

struct WeatherDataModel: Decodable {
    var maxTemperature: Int
    var date: Date
    var minTemperature: Int
    var weatherCondition: WeatherCondition
}
