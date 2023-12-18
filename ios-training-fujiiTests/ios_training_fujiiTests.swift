//
//  ios_training_fujiiTests.swift
//  ios-training-fujiiTests
//
//  Created by 藤井 紗良 on 2023/12/11.
//

import XCTest
@testable import ios_training_fujii

final class ios_training_fujiiTests: XCTestCase {
    
    func testWeatherConditionSunny() {
        let viewController = MainViewController()
        let weatherModelMock = WeatherModelMock()
        viewController.weatherModel = weatherModelMock

        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .sunny, maxTemperature: 20, minTemperature: 10)
        }
        
        viewController.reloadWeather(area: "tokyo")
        
        XCTAssertEqual(viewController.weatherImageView.image, UIImage(named: "sunny"))
        XCTAssertEqual(viewController.weatherImageView.tintColor, .red)
    }
    
}




