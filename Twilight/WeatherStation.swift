//
//  WeatherStation.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import SwiftyJSON

enum WeatherStationType {
    static let airport = "airport"
    static let personal = "pws"
}

class WeatherStation: NSObject {
    
    var city: String
    var state: String
    var country: String
    var coordinates: CoordinateLocation
    
    
    init(withDict dictionary: JSON) throws {
        
        guard let city = dictionary[LocationKey.city].string,
            let state = dictionary[LocationKey.state].string,
            let country = dictionary[LocationKey.country].string else {
                throw SerializationError.missing
        }
        
        let lat = dictionary[LocationKey.lat].object
        let lon = dictionary[LocationKey.lon].object
        
        self.city = city
        self.state = state
        self.country = country
        self.coordinates = CoordinateLocation(latitude: String(describing: lat), longitude: String(describing: lon))
    }
    
}

class PersonalWeatherStation: WeatherStation {
    var neighborhood: String
    var id: String
    var distanceKm: Int
    var distanceMile: Int

    override init(withDict dictionary: JSON) throws {
        do {
            
            guard let neighborhood = dictionary[LocationKey.neighborhood].string,
                let id = dictionary[LocationKey.id].string,
                let distanceKm = dictionary["distance_km"].int,
                let distanceMile = dictionary["distance_mi"].int else {
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
    
    override init(withDict dictionary : JSON) throws {
        do {
            
            guard let icao = dictionary["icao"].string else {
                throw SerializationError.missing
            }
            
            self.icao = icao
            
            try super.init(withDict: dictionary)
        }
    }
}
