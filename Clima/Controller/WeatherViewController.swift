//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation



class WeatherViewController: UIViewController {
    
    
    // LABELS

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    @IBOutlet weak var user_location: UIButton!
    
    
    // VARIABLES
    var weather_manager = WeatherManager()
    let location_manager = CLLocationManager()
    
    
    
    @IBOutlet weak var search_bar: UITextField!

    


// MARK: - UI MANAGER SECTION

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ALWAYS PUT THE LOCATION MANAGER BEFORE REQUESTING
        location_manager.delegate = self
        
        location_manager.requestWhenInUseAuthorization()
        location_manager.requestLocation()
        
        
        search_bar.delegate = self
        weather_manager.delegate = self

    }
    

}




// MARK: - UI TEXTFIELD SECTION

extension WeatherViewController: UITextFieldDelegate {
    
    
    
    @IBAction func search_button_pressed(_ sender: UIButton) {
        search_bar.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search_bar.endEditing(true)
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if let city = search_bar.text {
            weather_manager.fetch_weather(city)
        }
        
        search_bar.text = ""
        
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if search_bar.text == "" {
            search_bar.placeholder = "Type Something"
            return false
        } else {
            return true
        }
    }
    
}



//MARK: - WEATHER MANAGER SECTION

extension WeatherViewController: WeatherManagerDelegate {
    
    func did_update_weather(_ weather_manger: WeatherManager,_ weather: WeatherModel) {
        DispatchQueue.main.async() {
            self.temperatureLabel.text = weather.temperature_string
            self.conditionImageView.image = UIImage(systemName: weather.condition_name)
            self.cityLabel.text = weather.city_name
        }
    
    }
    
    
    func did_fail_with_error(_ error: Error) {
        print(error)
    }
    
}


//MARK: - LOCATION MANAGER SECTION

extension WeatherViewController: CLLocationManagerDelegate {
    
    
    @IBAction func user_location_pressed(_ sender: UIButton) {
        
        location_manager.requestWhenInUseAuthorization()
        
        location_manager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // GET PRECISE USER LOCATION
        if let location = locations.last {
            // STOP TRACKING THE LOCATION

            location_manager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weather_manager.fetch_weather(lat, long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
