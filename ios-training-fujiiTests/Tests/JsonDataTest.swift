//
//  JsonDataTest.swift
//  ios-training-fujiiTests
//
//  Created by 藤井 紗良 on 2023/12/18.
//

import XCTest
@testable import ios_training_fujii

final class JsonDataTest: XCTestCase {
    
    private var weatherModel: WeatherDataEncode & WeatherDataDecode = WeatherModelImpl()
    
    private var formatter = ISO8601DateFormatter()
    
    func testEncodeAPIRequest() {
        let date = Date()
        let requestDate = formatter.string(from: date)

        for area in ["tokyo", "hyogo"] {
                let apiRequest = "{\"area\":\"\(area)\",\"date\":\"\(requestDate)\"}"
                let reversedAPIRequest = "{\"date\":\"\(requestDate)\",\"area\":\"\(area)\"}"
                let encodeData: String
            
                do {
                    encodeData = try weatherModel.encodeAPIRequest(request: WeatherAPIRequest(area: area, date: date))
                } catch {
                    XCTFail(error.localizedDescription)
                    return
                }
                // APIのレスポンスが順不同なのでORで比較
                XCTAssert(encodeData == apiRequest || encodeData == reversedAPIRequest)
            }
    }
    
    func testDecodeAPIResponseCloudy() {
        let responseDate = getResponseDate()
        let apiResponse = """
            {
                "max_temperature":25,
                "date":"\(responseDate)",
                "min_temperature":7,
                "weather_condition":"cloudy"
            }
        """
        
        testDecodeRequest(apiResponse: apiResponse, weatherCondition: .cloudy)

    }
    
    func testDecodeAPIResponseSunny() {
        let responseDate = getResponseDate()
        let apiResponse = """
            {
                "max_temperature":25,
                "date":"\(responseDate)",
                "min_temperature":7,
                "weather_condition":"sunny"
            }
        """
        
        testDecodeRequest(apiResponse: apiResponse, weatherCondition: .sunny)
    }
    
    func testDecodeAPIResponseRainy() {
        let responseDate = getResponseDate()
        let apiResponse = """
            {
                "max_temperature":25,
                "date":"\(responseDate)",
                "min_temperature":7,
                "weather_condition":"rainy"
            }
        """
        
        testDecodeRequest(apiResponse: apiResponse, weatherCondition: .rainy)
    }
    
    func testDecodeAPIResponseFail() {
        let responseDate = getResponseDate()
        let apiResponse = """
            {
                "max_temperature":25,
                "date":"\(responseDate)",
                "min_temperature":7,
                "weather_condition":"snowy"
            }
        """
        
        XCTAssertThrowsError(try weatherModel.decodeAPIResponse(responseData: apiResponse)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    
    }
    
    private func getResponseDate() -> String {
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = Date()
        let responseDate = formatter.string(from: date)
        return responseDate
    }
    
    private func testDecodeRequest(apiResponse: String, weatherCondition: WeatherCondition) {
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = Date()
        let decodeData: WeatherDataModel
        
        let weatherData = WeatherDataModel(date: date, weatherCondition: weatherCondition, maxTemperature: 25, minTemperature: 7)
        
        do {
            decodeData = try weatherModel.decodeAPIResponse(responseData: apiResponse)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        XCTAssertEqual(decodeData, weatherData)
    }
}

extension WeatherDataModel: Equatable {
    public static func == (lhs: WeatherDataModel, rhs: WeatherDataModel) -> Bool {
        return Calendar.current.isDate(lhs.date, inSameDayAs: rhs.date)
        && lhs.weatherCondition == rhs.weatherCondition
        && lhs.maxTemperature == rhs.maxTemperature
        && lhs.minTemperature == rhs.minTemperature
    }
}
