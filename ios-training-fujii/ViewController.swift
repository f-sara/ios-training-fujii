//
//  ViewController.swift
//  ios-training-fujii
//
//  Created by 藤井 紗良 on 2023/12/11.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {

    @IBOutlet weak var weatherImageView: UIImageView!
    
    private var weatherImageString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeather()
    }
    
    @IBAction func weatherReloadButton() {

        fetchWeather()
    }
    
    func fetchWeather() -> Void {
        var weatherImage: UIImage!
        weatherImageString = YumemiWeather.fetchWeatherCondition()
        guard let weatherImageString else { return }
        
        weatherImage = UIImage(named: weatherImageString)
        weatherImageView.image = weatherImage
        
        switch weatherImageString {
        case "sunny":
            weatherImageView.tintColor = .red
        case "cloudy":
            weatherImageView.tintColor = .gray
        case "rainy":
            weatherImageView.tintColor = .blue
        default:
            return
        }
        
        print(weatherImageString)
        
    }


}

