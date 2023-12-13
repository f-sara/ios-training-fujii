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
            let weatherAPIRequest = """
            {
                "area": "tokyo",
                "date": "2020-04-01T12:00:00+09:00"
            }
            """
            let jsonString = try YumemiWeather.fetchWeather(weatherAPIRequest)
            let jsonData = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherDataModel.self, from: jsonData)
            setWeatherUI(weatherData: weatherData)
            
        } catch {
            let alert = UIAlertController(title: "エラー", message: "エラー(\(error))が発生しました。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "閉じる", style: .default))
            self.present(alert, animated: true, completion: nil)
            print(error)
        }
    }
    
    func setWeatherUI(weatherData: WeatherDataModel) {
        let weatherImage = UIImage(named: weatherData.weather_condition)
        let mimTemperature = String(weatherData.min_temperature)
        let maxTemperature = String(weatherData.max_temperature)
    
        weatherImageView.image = weatherImage
        minTemperatureLabel.text = mimTemperature
        maxTemperatureLabel.text = maxTemperature
        
        switch weatherData.weather_condition {
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

