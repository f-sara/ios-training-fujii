//
//  WeatherModel.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/18.
//

import Foundation
import YumemiWeather

/// @mockable
protocol WeatherModel {
    func fetchWeatherAPI(area: String) async throws -> WeatherDataModel
}

protocol WeatherDataEncodable {
    func encodeAPIRequest(request: WeatherAPIRequest) throws -> String
}

protocol WeatherDataDecodable {
    func decodeAPIResponse(responseData: String) throws -> WeatherDataModel
}

class WeatherModelImpl: WeatherModel, WeatherDataEncodable, WeatherDataDecodable {
    func fetchWeatherAPI(area: String) async throws -> WeatherDataModel {
        let date = Date()
        let weatherAPIRequest = WeatherAPIRequest(area: area, date: date)
        let requestAPIData = try encodeAPIRequest(request: weatherAPIRequest)
        let responseAPIData = try YumemiWeather.syncFetchWeather(requestAPIData)
        let weatherData = try decodeAPIResponse(responseData: responseAPIData)
        return weatherData
    }
    
    func encodeAPIRequest(request: WeatherAPIRequest) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(request)
        return String(data: data, encoding: .utf8)!
    }
    
    func decodeAPIResponse(responseData: String) throws -> WeatherDataModel {
        let jsonData = responseData.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let weatherData = try decoder.decode(WeatherDataModel.self, from: jsonData)
        return weatherData
    }
}


