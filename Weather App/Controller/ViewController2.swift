//
//  ViewController2.swift
//  Weather App
//
//  Created by David on 1/5/23.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var cityArray = [String]()
    var searchBarTextFiltered = String()
    var finalArray = [String]()
    var delegate: receiveCityProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        
        performRequest4()
    }
    
    func performRequest4() {
        guard let url = URL(string: "https://countriesnow.space/api/v0.1/countries") else {
            print("couldnt read url")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            guard let data else {return}
            
            if let result = try? JSONDecoder().decode(Cities.self, from: data) {
                DispatchQueue.main.async {
                    
                    for i in result.data {
                        
                        self.cityArray.append(contentsOf: i.cities)
                        self.cityArray.sort {$1>$0}
                        self.finalArray = self.cityArray
                    }
                    
                    self.table.reloadData()
                }
            }else {
                print("couldn't decode data")
            }
        }.resume()
    }

}

extension ViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if finalArray.count == 0 {
            return 1
        } else {
            return finalArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if finalArray.count == 0 {
            cell.textLabel?.text = "Loading Data, Please wait."
        } else {
            cell.textLabel?.text = finalArray[indexPath.row]
        }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(finalArray[indexPath.row])
        let cityToSend = finalArray[indexPath.row]
        delegate.receiveCity(string: cityToSend)
        self.dismiss(animated: true)
        
    }
    
    
}

extension ViewController2: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    finalArray = []
            for i in self.cityArray {
                if i.lowercased().hasPrefix(searchText.lowercased()) {
                    self.finalArray.append(i)
                }
            }
        
            print("error")
            table.reloadData()
        print("end", finalArray.count)
    }
}
