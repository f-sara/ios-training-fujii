//
//  WeatherModel.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/18.
//

import Foundation
import YumemiWeather

protocol MainPresenterOutput: AnyObject {
    func presenter(_ presenter: MainPresenter, weatherModel: WeatherDataModel)
    func presenter(_ presenter: MainPresenter, error: Error)
}

class MainPresenterImpl: MainPresenter {
    weak var output: MainPresenterOutput?
    
    init(output: MainPresenterOutput? = nil) {
        self.output = output
    }
    
    func fetchWeather(area: String) {
        let date = Date()

        Task.detached {
            do {
                let weatherAPIRequest = WeatherAPIRequest(area: area, date: date)
                let requestAPIData = try self.encodeAPIRequest(request: weatherAPIRequest)
                
                let responseAPIData = try YumemiWeather.syncFetchWeather(requestAPIData)
                let weatherData = try self.decodeAPIResponse(responseData: responseAPIData)
                self.output?.presenter(MainPresenterImpl(), weatherModel: weatherData)
            } catch {
                self.output?.presenter(MainPresenterImpl(), error: error)
            }
        }
    
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



