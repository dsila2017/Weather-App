//
//  ViewController.swift
//  Weather App
//
//  Created by David on 1/3/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    // MARK: - bottom half outlets
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var iconCode: String = "10d"
    
    // MARK: - url
    var urlString: String  {
        get {
            "https://api.openweathermap.org/data/2.5/weather?&appid=7d794f23b68cf9f043b0923eced7c96c&units=metric&q=" + textField.text!
        }
    }
    
    // MARK: - iconUrlString
    var iconUrlString: String {
        get {
        "https://openweathermap.org/img/wn/" + iconCode + "@2x.png"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }
    
    func performRequest(getUrlString: String) {
        guard let url = URL(string: getUrlString) else {
            print(getUrlString)
            print("couldnt read url")
            return
            
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            guard let data else {return}
            
            if let result = try? JSONDecoder().decode(MainWeather.self, from: data) {
                DispatchQueue.main.async {
                    self.updateLabels(weatherData: result)
                }
               
            }else {
                
                print("couldn't decode data")
            }
    
        }.resume()
        textField.text = .none
    }
    
    func performImageRequest(getUrlString: String) {
        guard let url = URL(string: getUrlString) else {
            print(getUrlString)
            print("couldnt read url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            guard let data else {return}
            
            DispatchQueue.main.async {
                
                self.iconImage.image = UIImage(data: data)
            }
    
        }.resume()
        textField.text = .none
    }
    
    func updateLabels(weatherData: MainWeather) {
        tempLabel.text = String(weatherData.main.temp) + "C"
        feelsLikeLabel.text = String(weatherData.main.feels_like)
        humidityLabel.text = String(weatherData.main.humidity)
        windSpeedLabel.text = String(weatherData.wind.speed)
        cityLabel.text = weatherData.name
        iconCode = weatherData.weather.first!.icon
        performImageRequest(getUrlString: iconUrlString)
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        textField.endEditing(true)
    }
    
}

// MARK: - Extension textField Delegate

extension ViewController: UITextFieldDelegate {
    
    // makes request when enter/go is pressed and hides the keyboard
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    // if there is no text in the textfield, placeholder text changes 
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            self.performRequest(getUrlString: urlString)
            textField.placeholder = "Enter city name.."
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}
