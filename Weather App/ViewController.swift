//
//  ViewController.swift
//  Weather App
//
//  Created by David on 1/3/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    // MARK: - bottom half outlets
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    // MARK: - url
    
    let urlString = "https://api.openweathermap.org/data/2.5/weather?q=kutaisi&appid=7d794f23b68cf9f043b0923eced7c96c&units=metric"
    
    var decodedWeather: MainWeather?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func performRequest() {
        guard let url = URL(string: urlString) else {
            print("couldnt read url")
            return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            guard let data else {return}
            
            if let result = try? JSONDecoder().decode(MainWeather.self, from: data) {
                self.decodedWeather = result
                DispatchQueue.main.async {
                    self.updateLabels(weatherData: result)
                }
               
            }else {
                print("couldn't decode data")
            }
    
        }.resume()
    }
    
    func updateLabels(weatherData: MainWeather) {
        tempLabel.text = String(weatherData.main.temp) + "C"
        feelsLikeLabel.text = String(weatherData.main.feels_like)
        humidityLabel.text = String(weatherData.main.humidity)
        windSpeedLabel.text = String(weatherData.wind.speed)
        cityLabel.text = weatherData.name
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        performRequest()
        
    }
    
}
