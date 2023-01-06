//
//  ViewController.swift
//  Weather App
//
//  Created by David on 1/3/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    var filteredData = [String]()
    
    // MARK: - bottom half outlets
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var iconCode: String = "10d"
    
    // MARK: - url
    var urlString: String  {
        get {
            "https://api.openweathermap.org/data/2.5/weather?&appid=7d794f23b68cf9f043b0923eced7c96c&units=metric&q=" + searchBar.text!
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
        searchBar.delegate = self
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func performRequest(getUrlString: String) {
        guard let url = URL(string: getUrlString) else {
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
                DispatchQueue.main.async {
                    self.alert()
                }
            }
        }.resume()
        searchBar.text = .none
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
        searchBar.text = .none
    }
    
    func updateLabels(weatherData: MainWeather) {
        tempLabel.text = String(weatherData.main.temp) + "C˚"
        feelsLikeLabel.text = String(weatherData.main.feels_like) + "˚"
        humidityLabel.text = String(weatherData.main.humidity) + "%"
        windSpeedLabel.text = String(weatherData.wind.speed) + "km/h"
        cityLabel.text = weatherData.name
        iconCode = weatherData.weather.first!.icon
        performImageRequest(getUrlString: iconUrlString)
    }
    
    func alert() {
        let refreshAlert = UIAlertController(title: "შეცდომა", message: "ასეთი ქალაქი ვერ მოიძებნა, გთხოვთ ქალაქი მოძებნოთ ჩვენს ბაზაში", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2
            
            vc?.delegate = self
            
            self.present(vc!, animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}

// MARK: - Extension textField Delegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("4", urlString)
        self.performRequest(getUrlString: urlString)
        view.endEditing(true)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2
        
        vc?.delegate = self
        
        self.present(vc!, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Ending")
    }
}

protocol receiveCityProtocol: AnyObject {
    func receiveCity(string: String)
}

extension ViewController: receiveCityProtocol {
    func receiveCity(string: String) {
        self.searchBar.text = string
        performRequest(getUrlString: urlString)
    }
}
