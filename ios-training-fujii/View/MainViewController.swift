//
//  ViewController.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/11.
//

import UIKit
import Combine

/// @mockable
protocol MainPresenter: AnyObject {
    func fetchWeather(area: String)
}

final class MainViewController: UIViewController {
    
    @IBOutlet @ViewLoading var weatherImageView: UIImageView
    @IBOutlet @ViewLoading var minTemperatureLabel: UILabel
    @IBOutlet @ViewLoading var maxTemperatureLabel: UILabel
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var cancellables = Set<AnyCancellable>()
    
    var presenter: MainPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenterImpl(output: self)
        
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] notification in
                self?.reloadWeather()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func reloadWeather() {
        reloadWeather(area: "tokyo")
    }
    
    @IBAction func closeView() {
        dismiss(animated: true)
    }
    
    func reloadWeather(area: String) {
        activityIndicator.startAnimating()
        presenter?.fetchWeather(area: "tokyo")
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

extension MainViewController: MainPresenterOutput {
    func presenter(_ presenter: MainPresenter, weatherModel: WeatherDataModel) {
        Task.detached { @MainActor in
            self.setWeatherUI(weatherData: weatherModel)
            self.activityIndicator.stopAnimating()
        }
    }
    func presenter(_ presenter: MainPresenter, error: Error) {
        Task.detached { @MainActor in
            self.handleWeatherError(error: error)
            self.activityIndicator.stopAnimating()
        }
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


