//
//  Location.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

enum LocationKey {
    
    static let type             = "type"
    static let country          = "country"
    static let countryIso3166   = "country_iso3166"
    static let countryName      = "country_name"
    static let state            = "state"
    static let city             = "city"
    static let timeZone         = "tz_short"
    static let lat              = "lat"
    static let lon              = "lon"
    static let elevation        = "elevation"
    static let zip              = "zip"
    static let wuiurl           = "wuiurl"
    static let nearbyStations   = "nearby_weather_stations"
    static let neighborhood     = "neighborhood"
    static let id               = "id"
    static let station          = "station"
}

enum SerializationError: Error {
    case missing
    case invalid
}

class Location: NSObject {
    
    var type: String?
    var country: String
    var countryISO3166: String
    var countryName: String?
    var state: String
    var city: String
    var timeZoneShort: String?
    var coordinates: CoordinateLocation
    var zip: String?
    var wuiURL: String?
    var nearbyWeatherStations = [WeatherStation]()

    init(withDict json: [String : Any]) throws {
        var longitudeKey = LocationKey.lon
        var latitudeKey = LocationKey.lat
        
        // Some responses have "longitude/latitude" instead of "lon/lat" -_-
        if json.keys.contains(where: {$0 == "latitude"}) {
            longitudeKey = "latitude"
            latitudeKey = "longitude"
        }

        // These fields are shared by all members of Location
        guard let country = json[LocationKey.country] as? String,
            let countryISO3166 = json[LocationKey.countryIso3166] as? String,
            let state = json[LocationKey.state] as? String,
            let city = json[LocationKey.city] as? String,
            let lat = json[latitudeKey] as? String,
            let lon =  json[longitudeKey] as? String else {
                throw SerializationError.missing
        }

        self.country = country
        self.countryISO3166 = countryISO3166
        self.state = state
        self.city = city
        self.coordinates = CoordinateLocation(latitude: lat, longitude: lon)
        
        // optional fields
        self.countryName = json[LocationKey.countryName] as? String
        self.zip = json[LocationKey.zip] as? String
        self.coordinates.elevation = json[LocationKey.elevation] as? String
        self.wuiURL = json[LocationKey.wuiurl] as? String
        self.timeZoneShort = json[LocationKey.timeZone] as? String
        self.type = json[LocationKey.type] as? String
        
        guard let nearbyStations = json[LocationKey.nearbyStations] as? [String : Any],
            let airportStations = nearbyStations[WeatherStationType.airport] as? [String : Any],
            let aStations = airportStations[LocationKey.station] as? [[String : String]] else { return }

        for station in aStations {
            do {
                let airportStation = try AirportWeatherStation(withDict: station)
                nearbyWeatherStations.append(airportStation)
            } catch {
                throw SerializationError.invalid
            }
        }

        guard let personalStations = nearbyStations[WeatherStationType.personal] as? [String : Any],
            let pStations = personalStations[LocationKey.station] as? [[String : Any]] else { return }
        
        for station in pStations {
            do {
                let personalStation = try PersonalWeatherStation(withDict: station)
                nearbyWeatherStations.append(personalStation)
            } catch {
               throw SerializationError.invalid
            }
        }
    }
}

class ObservationLocation : Location {
    var full: String
    
    override init(withDict dictionary : [String : Any]) throws {
        self.full = dictionary["full"] as! String
        try super.init(withDict: dictionary)
    }
}

class DisplayLocation : Location {
    var stateName: String
    
    override init(withDict dictionary : [String : Any]) throws {
        self.stateName = dictionary["state_name"] as! String
        try super.init(withDict: dictionary)
    }
}
