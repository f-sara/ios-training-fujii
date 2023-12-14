//
//  WeatherDataModel.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/12.
//

import Foundation

enum WeatherCondition: String, Decodable {
    case sunny
    case cloudy
    case rainy    
}

struct WeatherAPIRequest: Encodable {
    var area: String
    var date: Date
}

struct WeatherDataModel: Decodable {
    var date: Date
    var weatherCondition: WeatherCondition
    var maxTemperature: Int
    var minTemperature: Int
}
