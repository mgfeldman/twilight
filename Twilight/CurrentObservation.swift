//
//  CurrentObservation.swift
//  Twilight
//
//  Created by Mark on 9/10/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

let observationLocationKey = "observation_location"
let displayLocationKey     = "display_location"
let stationIDKey           = "station_id"
let observationTimeKey     = "observation_time"
let observationEpochKey    = "observation_epoch"
let weatherDescriptionKey  = "weather"
let temperatureStringKey   = "temperature_string"
let temperatureFKey        = "temp_f"
let temperatureCKey        = "temp_c"
let relativeHumidityKey    = "relative_humidity"
let windDescriptionKey     = "wind_string"
let feelsLikeFKey          = "feelslike_f"
let feelsLikeCKey          = "feelslike_c"
var iconURLKey             = "icon_url"

class CurrentObservation: NSObject {

    var observationLocation: ObservationLocation
    var displayLocation: DisplayLocation
    var stationID: String
    var observationTime: String
    var observationEpoch: String
    var weatherDescription: String
    var temperatureString: String
    var temperatureF: Double
    var temperatureC: Double
    var relativeHumidity: String
    var windDescription: String
    var feelsLikeF: String
    var feelsLikeC: String
    var iconURL: String
    
    var displayableWeatherString : String
    
    init(withDict dictionary : [String : Any]) throws {
        
        guard let observationLocation = dictionary[observationLocationKey],
            let displayLocation = dictionary[displayLocationKey],
            let stationID = dictionary[stationIDKey] as? String,
            let observationTime = dictionary[observationTimeKey] as? String,
            let observationEpoch = dictionary[observationEpochKey] as? String,
            let weatherDescription =  dictionary[weatherDescriptionKey] as? String,
            let temperatureString =  dictionary[temperatureStringKey] as? String,
            let temperatureF =  dictionary[temperatureFKey] as? Double,
            let temperatureC =  dictionary[temperatureCKey] as? Double,
            let relativeHumidity =  dictionary[relativeHumidityKey] as? String,
            let windDescription =  dictionary[windDescriptionKey] as? String,
            let feelsLikeF =  dictionary[feelsLikeFKey] as? String,
            let feelsLikeC =  dictionary[feelsLikeCKey] as? String,
            let iconURL =  dictionary[iconURLKey] as? String
            else {
                
                throw SerializationError.missing
        }
        
        self.observationLocation = try ObservationLocation(withDict: observationLocation as! [String : Any])
        self.displayLocation = try DisplayLocation(withDict: displayLocation as! [String : Any])
        self.stationID = stationID 
        self.observationTime = observationTime
        self.observationEpoch = observationEpoch
        self.weatherDescription = weatherDescription
        self.temperatureString = temperatureString
        self.temperatureF = temperatureF
        self.temperatureC = temperatureC
        self.relativeHumidity = relativeHumidity
        self.windDescription = windDescription
        self.feelsLikeF = feelsLikeF
        self.feelsLikeC = feelsLikeC
        self.iconURL = iconURL
        
        self.displayableWeatherString = String(Int(round(self.temperatureF))) + "˚"
    }
    
}

