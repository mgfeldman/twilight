//
//  Location.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

let locationTypeKey = "type"
let locationCountryKey = "country"
let locationCountryISO3116Key = "country_iso3166"
let locationCountryNameKey = "country_name"
let locationStateKey = "state"
let locationCityKey = "city"
let locationTimeZoneShortKey = "tz_short"
let locationLatitudeKey = "lat"
let locationLongitudeKey = "lon"
let locationZipKey = "zip"
let locationWuiURLKey = "wuiurl"
let locationNearbyWeatherStationsKey = "nearby_weather_stations"
let locationNeighborhoodKey = "neighborhood"
let locationIdKey = "id"
let locationStationKey = "station"

class Location: NSObject {
    
    var type : String?
    var country : String
    var countryISO3166 : String
    var countryName : String?
    var state : String
    var city : String
    var timeZoneShort : String?
    var coordinates : CoordinateLocation
    var zip : String?
    var wuiURL : String?
    var nearbyWeatherStations = [WeatherStation]()
    
    /// Creates an instance from the "location" response.
    ///
    /// - parameter dictionary: The "location" dictionary.
    /// - throws: JSONParsingError.InvalidPayload if dictionary is missing fields.
    init(withDict dictionary: Dictionary<String, Any>) throws {
        
        var longitudeKey = locationLongitudeKey
        var latitudeKey = locationLatitudeKey
        
        // Some responses have "longitude/latitude" instead of "lon/lat" -_-
        if dictionary.keys.contains(where: {$0 == "latitude"}) {
            longitudeKey = "latitude"
            latitudeKey = "longitude"
        }

        guard let country = dictionary[locationCountryKey],
            let countryISO3166 = dictionary[locationCountryISO3116Key],
            let state = dictionary[locationStateKey],
            let city = dictionary[locationCityKey],
            let lat = dictionary[latitudeKey],
            let lon =  dictionary[longitudeKey] else {
                
                throw JSONParsingError.InvalidPayload
        }

        self.country = country as! String
        self.countryISO3166 = countryISO3166 as! String
        self.state = state as! String
        self.city = city as! String
        self.coordinates = CoordinateLocation(latitude: lat as! String, longitude: lon as! String)
        
        if let countryName = dictionary[locationCountryNameKey] {
            self.countryName = countryName as? String
        }
        
        if let zip = dictionary[locationZipKey] {
            self.zip = zip as? String
        }
        
        if let elevation = dictionary["elevation"] {
            self.coordinates.elevation = elevation as? String
        }
        
        if let wuiURL = dictionary[locationWuiURLKey] {
            self.wuiURL = wuiURL as? String
        }
        
        if let timeZoneShort = dictionary[locationTimeZoneShortKey] {
            self.timeZoneShort = timeZoneShort as? String
        }
        
        if let type = dictionary[locationTypeKey] {
            self.type = type as? String
        }
        
        // TODO: Figure out how to separate this out and avoid the reference to 'self' issue
        if let nearbyStations = dictionary[locationNearbyWeatherStationsKey] as? Dictionary<String, Any> {
            if let airportStations = nearbyStations[WeatherStationType.airport.rawValue] as? [String : Any] {
                if let stations = airportStations[locationStationKey] as? [[String : String]] {
                    for station in stations {
                        do {
                            let airportStation = try AirportWeatherStation(withDict: station)
                            nearbyWeatherStations.append(airportStation)
                        } catch {
                            print("Error creating AirportWeatherStation.")
                        }
                    }
                }
            }
            
            if let personalStations = nearbyStations[WeatherStationType.personal.rawValue] as? [String : Any] {
                if let stations = personalStations[locationStationKey] as? [[String : Any]] {
                    for station in stations {
                        do {
                            let personalStation = try PersonalWeatherStation(withDict: station)
                            nearbyWeatherStations.append(personalStation)
                        } catch {
                            print("Error creating PersonalWeatherStation.")
                        }
                        
                    }
                }
            }
            
        }
    }
}

class ObservationLocation : Location {
    var full : String
    
    override init(withDict dictionary : [String : Any]) throws {
        self.full = dictionary["full"] as! String
        try super.init(withDict: dictionary)
    }
}

class DisplayLocation : Location {
    var stateName : String
    
    override init(withDict dictionary : [String : Any]) throws {
        self.stateName = dictionary["state_name"] as! String
        try super.init(withDict: dictionary)
    }
}


