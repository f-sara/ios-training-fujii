//
//  ViewController.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/11.
//

import UIKit
import YumemiWeather
import Combine

final class MainViewController: UIViewController {
    
    @IBOutlet @ViewLoading var weatherImageView: UIImageView
    @IBOutlet @ViewLoading var minTemperatureLabel: UILabel
    @IBOutlet @ViewLoading var maxTemperatureLabel: UILabel
    
    @IBOutlet @ViewLoading private var activityIndicator: UIActivityIndicatorView

    
    private var cancellables = Set<AnyCancellable>()
    
    var weatherModel: WeatherModel = WeatherModelImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] notification in
                self?.reloadWeather()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func reloadWeather() {
        Task {
            await reloadWeather(area: "tokyo")
        }
    }
    
    @IBAction func closeView() {
        dismiss(animated: true)
    }
    
    func reloadWeather(area: String) async {
        do {
            activityIndicator.startAnimating()
            let weatherData = try await weatherModel.fetchWeatherAPI(area: area)
            setWeatherUI(weatherData: weatherData)
            activityIndicator.stopAnimating()
        } catch {
            handleWeatherError(error: error)
            activityIndicator.stopAnimating()
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
