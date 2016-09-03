//
//  WeatherStation.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

enum WeatherStationType : String {
    case airport = "airport"
    case personal = "pws"
}

class WeatherStation : NSObject {
    
    var city : String
    var state : String
    var country : String
    
    init(withDict dictionary : Dictionary<String, Any>) throws {
        
        guard let city = dictionary[locationCityKey], let state = dictionary[locationStateKey],
            let country = dictionary[locationCountryKey] else {
                throw JSONParsingError.InvalidPayload
        }
        
        self.city = city as! String
        self.state = state as! String
        self.country = country as! String
    }
    
}

class PersonalWeatherStation : WeatherStation {
    var neighborhood : String
    var id : String
    var distanceKm : Int
    var distanceMile : Int
    
    override init(withDict dictionary : Dictionary<String, Any>) throws {
        do {
            
            guard let neighborhood = dictionary[locationNeighborhoodKey], let id = dictionary[locationIdKey], let distanceKm = dictionary["distance_km"], let distanceMile = dictionary["distance_mi"] else {
                throw JSONParsingError.InvalidPayload
            }
            
            self.neighborhood = neighborhood as! String
            self.id = id as! String
            self.distanceKm = distanceKm as! Int
            self.distanceMile = distanceMile as! Int
            
            try super.init(withDict: dictionary)
        }
    }
}

class AirportWeatherStation : WeatherStation {
    
    var icao : String
    var coordinates : CoordinateLocation
    
    override init(withDict dictionary : Dictionary<String, Any>) throws {
        do {
            
            guard let icao = dictionary["icao"], let lat = dictionary[locationLatitudeKey], let lon = dictionary[locationLongitudeKey] else {
                throw JSONParsingError.InvalidPayload
            }
            
            self.icao = icao as! String
            self.coordinates = CoordinateLocation(latitude: lat as! String, longitude: lon as! String)
            
            try super.init(withDict: dictionary)
        }
    }
}
