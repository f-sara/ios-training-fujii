//
//  ViewController.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/11.
//

import UIKit
import YumemiWeather

final class MainViewController: UIViewController {
    
    
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
    
    @IBAction func closeButton() {
        dismiss(animated: true)
    }
    
    func reloadWeather(area: String) {
        do {
            let weatherData = try fetchWeatherAPI(area: area)
            setWeatherUI(weatherData: weatherData)
        } catch {
            handleWeatherError(error: error)
        }
    }
    
    private func handleWeatherError(error: Error) {
        var title: String
        switch error {
        case is EncodingError:
            title = "エンコードエラー"
        case is DecodingError:
            title = "デコードエラー"
        default:
            title = "APIエラー"
        }
        let message = "\(error)が発生しました。"
        showAlert(title: title, message: message)
    }
    
    private func encodeAPIRequest(request: WeatherAPIRequest) throws -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(request)
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
        let weatherAPIRequest = WeatherAPIRequest(area: area, date: date)
        let requestAPIData = try encodeAPIRequest(request: weatherAPIRequest)
        let responseAPIData = try YumemiWeather.fetchWeather(requestAPIData)
        let weatherData = try decodeAPIResponse(responseData: responseAPIData)
        return weatherData
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default))
        self.present(alert, animated: true)
    }
    
    private func setWeatherUI(weatherData: WeatherDataModel) {
        let weatherCondition = weatherData.weatherCondition
        let mimTemperature = String(weatherData.minTemperature)
        let maxTemperature = String(weatherData.maxTemperature)
        
        weatherImageView.image = weatherCondition.weatherImage
        weatherImageView.tintColor = weatherCondition.tintColor
        minTemperatureLabel.text = mimTemperature
        maxTemperatureLabel.text = maxTemperature
    }
    
    
    
}

extension WeatherCondition {
    var weatherImage: UIImage {
        return UIImage(named: rawValue) ?? {
            assertionFailure("UIImage(named: \(rawValue)) returned nil.")
            return UIImage()
        }()
    }
    
    var tintColor: UIColor {
        switch self {
        case .sunny:
            return .red
        case .cloudy:
            return .gray
        case .rainy:
            return .blue
        }
    }
}
