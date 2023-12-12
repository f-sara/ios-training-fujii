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
        
        fetchWeather(area: "tokyo")
    }
    
    @IBAction func weatherReloadButton() {

        fetchWeather(area: "tokyo")
    }
    
    func fetchWeather(area: String) -> Void {
        do {
            let weatherImageString = try YumemiWeather.fetchWeatherCondition(at: area)
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
            
        } catch {
            let alert = UIAlertController(title: "エラー", message: "エラー(\(error))が発生しました。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "閉じる", style: .default))
            self.present(alert, animated: true, completion: nil)
            print(error)
        }
    }


}

