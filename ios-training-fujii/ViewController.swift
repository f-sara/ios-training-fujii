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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeather()
    }
    
    @IBAction func weatherReloadButton() {

        fetchWeather()
    }
    
    func fetchWeather() -> Void {
        let weatherImageString: String = YumemiWeather.fetchWeatherCondition()
        let weatherImage = UIImage(named: weatherImageString)
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

