//
//  Networking.swift
//  Weather App
//
//  Created by Davit Natenadze on 07.01.23.
//

import Foundation

struct Networking {
    
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
                    print("Temp: \(result.main.temp), Name:  \(result.name)")
                }
            }else {
                print("couldn't decode data")
              
            }
        }.resume()
    }
}
