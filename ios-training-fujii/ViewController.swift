//
//  ViewController.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/11.
//

import UIKit
import YumemiWeather

final class ViewController: UIViewController {


    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeatherAPI(area: "tokyo")
    }
    
    @IBAction func weatherReloadButton() {
        
        fetchWeatherAPI(area: "tokyo")
    }
    
    func fetchWeatherAPI(area: String) -> Void {
        do {
            let date = getDate()
            let weatherAPIRequest = WeatherAPIRequest(area: area, date: date)
            let jsonRequest = try JSONEncoder().encode(weatherAPIRequest)
            let stringRequest = String(data: jsonRequest, encoding: .utf8)!
            let jsonString = try YumemiWeather.fetchWeather(stringRequest)
            let jsonData = jsonString.data(using: .utf8)!
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let weatherData = try jsonDecoder.decode(WeatherDataModel.self, from: jsonData)
            setWeatherUI(weatherData: weatherData)
            
        } catch {
            showAlert(error: error)
        }
    }
    
    private func getDate() -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return dateFormatter.string(from: Date())
    }
    
    private func showAlert(error: Error) {
        let alert = UIAlertController(title: "エラー", message: "エラー(\(error))が発生しました。", preferredStyle: .alert)
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

