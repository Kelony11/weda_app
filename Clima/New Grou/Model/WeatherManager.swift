//
//  weather_manger.swift
//  Clima
//
//  Created by Kelvin Ihezue on 1/16/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    
    func did_update_weather(_ weather_manager: WeatherManager,_ weather: WeatherModel)
    func did_fail_with_error(_ error: Error)
}

struct WeatherManager {
    
    // VARIABLES
    var delegate: WeatherManagerDelegate?
    
    
    let weather_url = "https://api.openweathermap.org/data/2.5/weather?appid=03813e4d85cdeb2088272a963598578b&units=imperial"
    
    func fetch_weather(_ city_name: String) {
        let url_string = "\(weather_url)&q=\(city_name)"
        perform_request(url_string)
        print(url_string)
    }
    
    
    func fetch_weather(_ latitude: CLLocationDegrees,_ longitute: CLLocationDegrees){
        let url_string = "\(weather_url)&lat=\(latitude)&lon=\(longitute)"
        perform_request(url_string)
        print(url_string)
        
    }

    
    func perform_request(_ url_string: String) {
        
        // 1.  CREATE A URL
        if let url = URL(string: url_string) {
            
            // 2. CREATE A URL SESSION
            let session = URLSession(configuration: .default)
            
            // 3. GIVE THE SESSION A TASK
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.did_fail_with_error(error!)
                    return
                }
                
                if let safe_data = data {
                    if let weather = self.parse_Json(weather_data: safe_data) {
                        delegate?.did_update_weather(self, weather)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    


    func parse_Json(weather_data: Data) -> WeatherModel?  {
        let decoder = JSONDecoder()
        do {
            let decoded_data = try decoder.decode(WeatherData.self, from: weather_data)
            
            let id = decoded_data.weather[0].id
            let city_name = decoded_data.name
            let temp = decoded_data.main.temp
            
            
            // TRANSFERRING IT TO A DIFFERENT FILE
            let weather = WeatherModel(condition_id: id, city_name: city_name, temperature: temp)
            
            print(weather.temperature_string)
            
            print(weather.city_name)
            
            return weather
        
        } catch {
            self.delegate?.did_fail_with_error(error)
            return nil
        }

            
    }
    
    
      
}
