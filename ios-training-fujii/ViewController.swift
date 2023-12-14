//
//  ViewController.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/11.
//

import UIKit
import YumemiWeather

final class ViewController: UIViewController {
    
    
    @IBOutlet @ViewLoading private var weatherImageView: UIImageView
    @IBOutlet @ViewLoading private var minTemperatureLabel: UILabel
    @IBOutlet @ViewLoading private var maxTemperatureLabel: UILabel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadWeather(area: "tokyo")
    }
    
    @IBAction func weatherReloadButton() {
        
        reloadWeather(area: "tokyo")
    }
    
    func reloadWeather(area: String) -> Void {
        do {
            let weatherData = try fetchWeatherAPI(area: area)
            setWeatherUI(weatherData: weatherData)
        } catch {
            switch error {
            case is EncodingError:
                print("エンコードエラー:\(error)")
                showAlert(title: "エンコードエラー", error: error)
            case is DecodingError:
                print("デコードエラー：\(error)")
                showAlert(title: "デコードエラー", error: error)
            default:
                print("APIエラー:\(error)")
                showAlert(title: "APIエラー", error: error)
            }
        }
    }
    
    private func encodeAPIRequest(area: String, date: Date) throws -> String {
        let weatherAPIRequest = WeatherAPIRequest(area: area, date: date)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(weatherAPIRequest)
        return String(data: data, encoding: .utf8)!
    }
    
    private func decodeAPIResponse(responseData: String) throws -> WeatherDataModel {
        let jsonData = responseData.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let weatherData = try decoder.decode(WeatherDataModel.self, from: jsonData)
        return weatherData
    }
    
    private func fetchWeatherAPI(area: String) throws -> WeatherDataModel {
        let date = Date()
        let requestAPIData = try encodeAPIRequest(area: area, date: date)
        let responseAPIData = try YumemiWeather.fetchWeather(requestAPIData)
        let weatherData = try decodeAPIResponse(responseData: responseAPIData)
        return weatherData
    }
    
    private func showAlert(title: String, error: Error) {
        let alert = UIAlertController(title: title, message: "\(error)が発生しました。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setWeatherUI(weatherData: WeatherDataModel) {
        let weatherImage = UIImage(named: weatherData.weatherCondition)
        let mimTemperature = String(weatherData.minTemperature)
        let maxTemperature = String(weatherData.maxTemperature)
        
        weatherImageView.image = weatherImage
        minTemperatureLabel.text = mimTemperature
        maxTemperatureLabel.text = maxTemperature
        
        switch weatherData.weatherCondition {
        case "sunny":
            weatherImageView.tintColor = .red
        case "cloudy":
            weatherImageView.tintColor = .gray
        case "rainy":
            weatherImageView.tintColor = .blue
        default:
            weatherImageView.tintColor = .clear
        }
        
    }
    
    
    
}

