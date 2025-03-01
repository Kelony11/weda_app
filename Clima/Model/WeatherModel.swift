//
//  WeatherModel.swift
//  Clima
//
//  Created by Kelvin Ihezue on 1/18/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let condition_id: Int
    let city_name: String
    let temperature: Double
    
    
    var temperature_string : String {
        return String(format: "%.0f", temperature)
    }

    
    var condition_name: String {
       
        switch condition_id {
            case 200...232: return "cloud.bolt"
            case 300...321: return "cloud.drizzle"
            case 500...531: return "cloud.rain"
            case 600...622: return "cloud.snow"
            case 701...781: return "cloud.fog"
            case 800: return "sun.max"
            case 801...804: return "cloud.bolt"
            default: return "cloud"
        }
        
    }
        
        

}
