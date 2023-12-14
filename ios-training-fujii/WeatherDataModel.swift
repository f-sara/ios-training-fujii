//
//  WeatherDataModel.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/12.
//

import Foundation

struct WeatherAPIRequest: Encodable {
    var area: String
    var date: Date
}

struct WeatherDataModel: Decodable {
    var maxTemperature: Int
    var date: Date
    var minTemperature: Int
    var weatherCondition: String
}