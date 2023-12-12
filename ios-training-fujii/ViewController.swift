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
    var weatherImage: UIImage!
    
    private var weatherImageString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeather()
    }
    
    @IBAction func weatherReloadButton() {

        fetchWeather()
    }
    
    func fetchWeather() -> Void {
        weatherImageString = YumemiWeather.fetchWeatherCondition()
        guard let weatherImageString = weatherImageString else { return }
        
        weatherImage = UIImage(named: weatherImageString)
        weatherImageView.image = weatherImage
        print(weatherImageString)
        
    }


}

