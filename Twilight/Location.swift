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
    
    var type : String
    var country : String
    var countryISO3166 : String
    var countryName : String
    var state : String
    var city : String
    var timeZoneShort : String
    var coordinates : CoordinateLocation
    var zip : String
    var wuiURL : String
    var nearbyWeatherStations = [WeatherStation]()
    
    /// Creates an instance from the "location" response.
    ///
    /// - parameter dictionary: The "location" dictionary.
    /// - throws: JSONParsingError.InvalidPayload if dictionary is missing fields.
    init(withDict dictionary: Dictionary<String, Any>) throws {
        
        guard let type = dictionary[locationTypeKey], let country = dictionary[locationCountryKey],
            let countryISO3166 = dictionary[locationCountryISO3116Key],
            let countryName = dictionary[locationCountryNameKey], let state = dictionary[locationStateKey],
            let city = dictionary[locationCityKey], let timeZoneShort = dictionary[locationTimeZoneShortKey],
            let lat = dictionary[locationLatitudeKey], let lon =  dictionary[locationLongitudeKey],
            let zip = dictionary[locationZipKey], let wuiURL = dictionary[locationWuiURLKey]  else {
                
                throw JSONParsingError.InvalidPayload
        }
        
        self.type = type as! String
        self.country = country as! String
        self.countryISO3166 = countryISO3166 as! String
        self.countryName = countryName as! String
        self.state = state as! String
        self.city = city as! String
        self.timeZoneShort = timeZoneShort as! String
        self.coordinates = CoordinateLocation(latitude: lat as! String, longitude: lon as! String)
        self.zip = zip as! String
        self.wuiURL = wuiURL as! String
        
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

