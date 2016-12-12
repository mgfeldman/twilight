//
//  WeatherStation.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

enum WeatherStationType {
    static let airport = "airport"
    static let personal = "pws"
}

class WeatherStation : NSObject {
    
    var city: String
    var state: String
    var country: String
    var coordinates: CoordinateLocation
    
    
    init(withDict dictionary : [String: Any]) throws {
        
        guard let city = dictionary[LocationKey.city] as? String,
            let state = dictionary[LocationKey.state] as? String,
            let country = dictionary[LocationKey.country] as? String,
            let lat = dictionary[LocationKey.lat],
            let lon = dictionary[LocationKey.lon] else {
                throw SerializationError.missing
        }
        
        self.city = city
        self.state = state
        self.country = country
        self.coordinates = CoordinateLocation(latitude: String(describing: lat), longitude: String(describing: lon))
    }
    
}

class PersonalWeatherStation : WeatherStation {
    var neighborhood: String
    var id: String
    var distanceKm: Int
    var distanceMile: Int

    override init(withDict dictionary : [String: Any]) throws {
        do {
            
            guard let neighborhood = dictionary[LocationKey.neighborhood] as? String,
                let id = dictionary[LocationKey.id] as? String,
                let distanceKm = dictionary["distance_km"] as? Int,
                let distanceMile = dictionary["distance_mi"] as? Int else {
                throw SerializationError.missing
            }
            
            self.neighborhood = neighborhood
            self.id = id
            self.distanceKm = distanceKm
            self.distanceMile = distanceMile

            try super.init(withDict: dictionary)
        }
    }
}

class AirportWeatherStation : WeatherStation {
    
    var icao: String
    
    override init(withDict dictionary : [String: Any]) throws {
        do {
            
            guard let icao = dictionary["icao"] as? String else {
                throw SerializationError.missing
            }
            
            self.icao = icao
            
            try super.init(withDict: dictionary)
        }
    }
}
