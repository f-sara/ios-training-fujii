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
    
    override func setUp() {
        super.setUp()
    }
     
    
    func testEncodeAPIRequest() {
        let date = Date()
        let requestDate = formatter.string(from: date)
        let encodeData: String
        let encodeDataHyogo: String
        let apiRequest = "{\"area\":\"tokyo\",\"date\":\"\(requestDate)\"}"
        let reversedAPIRequest = "{\"date\":\"\(requestDate)\",\"area\":\"tokyo\"}"
        let apiRequestHyogo = "{\"area\":\"hyogo\",\"date\":\"\(requestDate)\"}"
        let reversedAPIRequestHyogo = "{\"date\":\"\(requestDate)\",\"area\":\"hyogo\"}"
        
        do {
            encodeData = try weatherModel.encodeAPIRequest(request: WeatherAPIRequest(area: "tokyo", date: date))
            encodeDataHyogo = try weatherModel.encodeAPIRequest(request: WeatherAPIRequest(area: "hyogo", date: date))
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        // APIのレスポンスが順不同なのでORで比較
        XCTAssert(encodeData == apiRequest || encodeData == reversedAPIRequest)
        XCTAssert(encodeDataHyogo == apiRequestHyogo || encodeDataHyogo == reversedAPIRequestHyogo)
    }
    
    func testDecodeAPIResponse() {
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = Date()
        let responseDate = formatter.string(from: date)
        let decodeData: WeatherDataModel
        
        let apiResponse = """
            {
                "max_temperature":25,
                "date":"\(responseDate)",
                "min_temperature":7,
                "weather_condition":"cloudy"
            }
        """
        
        print(apiResponse)
        
        let weatherData = WeatherDataModel(date: date, weatherCondition: .cloudy, maxTemperature: 25, minTemperature: 7)
        
        do {
            decodeData = try weatherModel.decodeAPIResponse(responseData: apiResponse)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        XCTAssertEqual(decodeData, weatherData)

    }
    
    func testDecodeAPIResponseFail() {
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = Date()
        let responseDate = formatter.string(from: date)
        
        let apiResponse = """
            {
                "max_temperature":25,
                "date":"\(responseDate)",
                "min_temperature":7,
                "weather_condition":"snowy"
            }
        """
        
        print(apiResponse)
        
        XCTAssertThrowsError(try weatherModel.decodeAPIResponse(responseData: apiResponse)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    
    }
    
    func testDecodeAPIResponseSunny() {
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = Date()
        let responseDate = formatter.string(from: date)
        let decodeData: WeatherDataModel
        
        let apiResponse = """
            {
                "max_temperature":25,
                "date":"\(responseDate)",
                "min_temperature":7,
                "weather_condition":"sunny"
            }
        """
        
        print(apiResponse)
        
        let weatherData = WeatherDataModel(date: date, weatherCondition: .sunny, maxTemperature: 25, minTemperature: 7)
        
        do {
            decodeData = try weatherModel.decodeAPIResponse(responseData: apiResponse)
        } catch {
            XCTFail(error.localizedDescription)
            return
        }
        
        XCTAssertEqual(decodeData, weatherData)

    }
    
    func testDecodeAPIResponseRainy() {
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let date = Date()
        let responseDate = formatter.string(from: date)
        let decodeData: WeatherDataModel
        
        let apiResponse = """
            {
                "max_temperature":25,
                "date":"\(responseDate)",
                "min_temperature":7,
                "weather_condition":"rainy"
            }
        """
        
        print(apiResponse)
        
        let weatherData = WeatherDataModel(date: date, weatherCondition: .rainy, maxTemperature: 25, minTemperature: 7)
        
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
