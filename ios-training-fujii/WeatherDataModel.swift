//
//  WeatherDataModel.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/12.
//

import Foundation

struct WeatherAPIRequest: Codable {
    var area: String
    var date: String
}

struct WeatherDataModel: Codable {
    var max_temperature: Int
    var date: String
    var min_temperature: Int
    var weather_condition: String
}
