//
//  CurrentObservation.swift
//  Twilight
//
//  Created by Mark on 9/10/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    
    init(withDict dictionary: JSON) throws {
        
        guard dictionary[observationLocationKey].exists(),
            dictionary[displayLocationKey].exists(),
            let stationID = dictionary[stationIDKey].string,
            let observationTime = dictionary[observationTimeKey].string,
            let observationEpoch = dictionary[observationEpochKey].string,
            let weatherDescription =  dictionary[weatherDescriptionKey].string,
            let temperatureString =  dictionary[temperatureStringKey].string,
            let temperatureF =  dictionary[temperatureFKey].double,
            let temperatureC =  dictionary[temperatureCKey].double,
            let relativeHumidity =  dictionary[relativeHumidityKey].string,
            let windDescription =  dictionary[windDescriptionKey].string,
            let feelsLikeF =  dictionary[feelsLikeFKey].string,
            let feelsLikeC =  dictionary[feelsLikeCKey].string,
            let iconURL =  dictionary[iconURLKey].string
            else {
                
                throw SerializationError.missing
        }
        
        self.observationLocation = try ObservationLocation(withDict: dictionary[observationLocationKey])
        self.displayLocation = try DisplayLocation(withDict: dictionary[displayLocationKey])
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

