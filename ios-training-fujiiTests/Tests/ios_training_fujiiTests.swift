//
//  ios_training_fujiiTests.swift
//  ios-training-fujiiTests
//
//  Created by 藤井 紗良 on 2023/12/11.
//

import XCTest
@testable import ios_training_fujii

final class ios_training_fujiiTests: XCTestCase {
    private let mainViewController: MainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "mainViewController")
//    private let mainViewController: MainViewController = MainViewController()
    private var weatherModelMock: WeatherModelMock = WeatherModelMock()
    
    override func setUp() {
        super.setUp()
        // testViewWillEnterForegroundを呼ぶためににviewLoadingを初期化
        mainViewController.weatherImageView.image = UIImage()
        mainViewController.minTemperatureLabel.text = ""
        mainViewController.maxTemperatureLabel.text = ""
        weatherModelMock = WeatherModelMock()
    }
    
    func testWeatherConditionSunny() {
        mainViewController.weatherModel = weatherModelMock

        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .sunny, maxTemperature: 20, minTemperature: 10)
        }
        
        mainViewController.reloadWeather()
        
        XCTAssertEqual(mainViewController.weatherImageView.image, UIImage(named: "sunny"))
        XCTAssertEqual(mainViewController.weatherImageView.tintColor, .red)
    }
    
    func testWeatherConditionRainy() {
        mainViewController.weatherModel = weatherModelMock

        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .rainy, maxTemperature: 20, minTemperature: 10)
        }
        
        mainViewController.reloadWeather()
        
        XCTAssertEqual(mainViewController.weatherImageView.image, UIImage(named: "rainy"))
        XCTAssertEqual(mainViewController.weatherImageView.tintColor, .blue)
    }
    
    func testWeatherConditionCloudy() {
        mainViewController.weatherModel = weatherModelMock

        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .cloudy, maxTemperature: 20, minTemperature: 10)
        }
        
        mainViewController.reloadWeather()
        
        XCTAssertEqual(mainViewController.weatherImageView.image, UIImage(named: "cloudy"))
        XCTAssertEqual(mainViewController.weatherImageView.tintColor, .gray)
    }
    
    func testWeatherTemperatureLabel() {
        mainViewController.weatherModel = weatherModelMock

        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .sunny, maxTemperature: 20, minTemperature: 10)
        }
        
        mainViewController.reloadWeather()
        
        XCTAssertEqual(mainViewController.maxTemperatureLabel.text, "20")
        XCTAssertEqual(mainViewController.minTemperatureLabel.text, "10")
    }
    
    func testViewWillEnterForeground() {
        mainViewController.weatherModel = weatherModelMock
        weatherModelMock.fetchWeatherAPIHandler = { _ in
            return WeatherDataModel(date: Date(), weatherCondition: .cloudy, maxTemperature: 20, minTemperature: 10)
        }
        
        
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        
        XCTAssertEqual(mainViewController.weatherImageView.image, UIImage(named: "cloudy"))
        XCTAssertEqual(mainViewController.maxTemperatureLabel.text, "20")
        XCTAssertEqual(mainViewController.minTemperatureLabel.text, "10")
        
    }
    
}




