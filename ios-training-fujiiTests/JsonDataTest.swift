//
//  JsonDataTest.swift
//  ios-training-fujiiTests
//
//  Created by 藤井 紗良 on 2023/12/18.
//

import XCTest
@testable import ios_training_fujii

final class JsonDataTest: XCTestCase {
    private var weatherModelMock: WeatherModelMock = WeatherModelMock()
    
    override func setUp() {
        super.setUp()
        weatherModelMock = WeatherModelMock()
    }
     
    
    func testEncodeAPIRequest() {
        let encodeMock: WeatherDataEncodeMock = WeatherDataEncodeMock()
        let date = Date()
        let encodeData: String
        let apiRequest = """
            {
                "area": "tokyo",
                "date": "2020-04-01T12:00:00+09:00"
            }
        """
        
        encodeMock.encodeAPIRequestHandler = { request in
            XCTAssertEqual(request.area, "tokyo")
            XCTAssertEqual(request.date, date)
            return apiRequest
        }

        do {
            encodeData = try encodeMock.encodeAPIRequest(request: WeatherAPIRequest(area: "tokyo", date: date))
        } catch {
            encodeData = ""
        }
        
        XCTAssertEqual(encodeData, apiRequest)
    }
    
    func testDecodeAPIResponse() {
        let decodeMock: WeatherDataDecodeMock = WeatherDataDecodeMock()
        let date = Date()
        let decodeData: WeatherDataModel
        
        let apiResponse = """
            {
                "max_temperature":25,
                "date":"\(date)",
                "min_temperature":7,
                "weather_condition":"cloudy"
            }
        """
        
        decodeMock.decodeAPIResponseHandler = { response in
            XCTAssertEqual(response, apiResponse)
            return WeatherDataModel(date: date, weatherCondition: .cloudy, maxTemperature: 25, minTemperature: 7)
        }
        
        do {
            decodeData = try decodeMock.decodeAPIResponse(responseData: apiResponse)
        } catch {
            decodeData = WeatherDataModel(date: Date(timeInterval: 60, since: .now), weatherCondition: .sunny, maxTemperature: 10, minTemperature: 10)
        }
        
        XCTAssertEqual(decodeData.date, date)
        XCTAssertEqual(decodeData.weatherCondition, .cloudy)
        XCTAssertEqual(decodeData.maxTemperature, 25)
        XCTAssertEqual(decodeData.minTemperature, 7)
    }
}
