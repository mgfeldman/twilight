//
//  WUResponse.swift
//  Twilight
//
//  Created by Mark on 12/11/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import SwiftyJSON

class WUResponse: NSObject {
    var location: Location?
    var conditions: CurrentObservation?
    var forecast: Forecast?
    // future response types go here
    
    override init() {
        
    }
    
    func parseFeatures(json: JSON) {
        let responseFeatures = json["response"]["features"]
        
        // If response contains geolookup, parse the information
        if responseFeatures[WUFeatureType.geolookup.stringValue] == 1 {
            parseLocation(response: json)
        }
        
        if responseFeatures[WUFeatureType.conditions.stringValue] == 1 {
            parseConditions(response: json)
        }
        
        if responseFeatures[WUFeatureType.forecast.stringValue] == 1 {
            parseForecast(response: json)
        }
    }
    
    private func parseLocation(response: JSON) {
        do {
            location = try Location(withDict: response["location"])
        } catch let error as SerializationError {
            log.error(error.localizedDescription)
        } catch {
            log.error("Unknown Error parsing Location object.")
        }
    }
    
    private func parseConditions(response: JSON) {
        do {
            conditions = try CurrentObservation(withDict: response["current_observation"])
        } catch let error as SerializationError {
            log.error(error.localizedDescription)
        } catch {
            log.error("Unknown Error parsing Conditions object.")
        }
    }
    
    private func parseForecast(response: JSON) {
        do {
            forecast = try Forecast(withDict: response["forecast"])
        } catch let error as SerializationError {
            log.error(error.localizedDescription)
        } catch {
            log.error("Unknown Error parsing Forecast object.")
        }
    }
}

public struct WUAutoCompleteResponse {
    
    var results = [WUAutoCompleteResult]()
    var cities: [WUAutoCompleteResult] {
        get {
            return results.filter{$0.type == "city"}
        }
    }
    
    init() {
        
    }
    
    init(withJson json: JSON) {
        if let resultsArray = json["RESULTS"].array {
            for result in resultsArray  {
                results.append(WUAutoCompleteResult(withJson: result))
            }
        }
    }
}

class WUAutoCompleteResult: NSObject {
    var city: String
    var country: String
    var type: String
    var requestLink: String
    var location: CoordinateLocation?
    
    init(withJson json: JSON) {
        self.city = json["name"].stringValue
        self.country = json["c"].stringValue
        self.type = json["type"].stringValue
        self.requestLink = json["l"].stringValue
        
        if let lat = json["lat"].string, let lon = json["lon"].string {
            self.location = CoordinateLocation(latitude: lat, longitude: lon)
        }
    }
}
