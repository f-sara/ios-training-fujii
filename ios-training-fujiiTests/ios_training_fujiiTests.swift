//
//  ios_training_fujiiTests.swift
//  ios-training-fujiiTests
//
//  Created by 藤井 紗良 on 2023/12/11.
//

import XCTest
@testable import ios_training_fujii

final class ios_training_fujiiTests: XCTestCase {
    private var mainViewController: MainViewController = MainViewController()
    private var weatherModelMock: WeatherModelMock = WeatherModelMock()
    
    override func setUp() {
        super.setUp()
        mainViewController = MainViewController()
        weatherModelMock = WeatherModelMock()
    }
    
    func testWeatherConditionSunny() {
        mainViewController.weatherModel = weatherModelMock

        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .sunny, maxTemperature: 20, minTemperature: 10)
        }
        
        mainViewController.reloadWeather(area: "tokyo")
        
        XCTAssertEqual(mainViewController.weatherImageView.image, UIImage(named: "sunny"))
        XCTAssertEqual(mainViewController.weatherImageView.tintColor, .red)
    }
    
    func testWeatherConditionRainy() {
        mainViewController.weatherModel = weatherModelMock

        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .rainy, maxTemperature: 20, minTemperature: 10)
        }
        
        mainViewController.reloadWeather(area: "tokyo")
        
        XCTAssertEqual(mainViewController.weatherImageView.image, UIImage(named: "rainy"))
        XCTAssertEqual(mainViewController.weatherImageView.tintColor, .blue)
    }
    
    func testWeatherConditionCloudy() {
        mainViewController.weatherModel = weatherModelMock

        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .cloudy, maxTemperature: 20, minTemperature: 10)
        }
        
        mainViewController.reloadWeather(area: "tokyo")
        
        XCTAssertEqual(mainViewController.weatherImageView.image, UIImage(named: "cloudy"))
        XCTAssertEqual(mainViewController.weatherImageView.tintColor, .gray)
    }
    
    func testWeatherTemperatureLabel() {
        mainViewController.weatherModel = weatherModelMock

        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .sunny, maxTemperature: 20, minTemperature: 10)
        }
        
        mainViewController.reloadWeather(area: "tokyo")
        
        XCTAssertEqual(mainViewController.maxTemperatureLabel.text, "20")
        XCTAssertEqual(mainViewController.minTemperatureLabel.text, "10")
    }
    
}




