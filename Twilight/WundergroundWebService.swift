//
//  WundergroundWebService.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import Alamofire

public enum FeatureParams : String {
    case conditions    = "conditions"
    case geolookup     = "geolookup"
    case forecast      = "forecast"
    case alerts        = "alerts"
    case forecast10day = "forecast10day"
    case history       = "history"
    case hourly        = "hourly"
    case hourly10day   = "hourly10day"
    case planner       = "planner"
    case rawtide       = "rawtide"
    case tide          = "tide"
    case webcams       = "webcams"
    case yesterday     = "yesterday"
    
    var stringValue : String {
        return self.rawValue
    }
}
protocol WundergroundInformationDelegate {
    func locationInformationUpdated(location : Location)
}

class WundergroundWebService: NSObject, LocationServicesDelegate {
    static let shared = WundergroundWebService()
    let apiKey = "005ecab154b1d3ca"
    let baseURL = "http://api.wunderground.com/api/"
    private var delegates = [WundergroundInformationDelegate]()
    
    override init() {
        super.init()
        LocationServices.shared.subscribe(delegate: self)
    }
    
    deinit {
        delegates.removeAll()
    }
    
    func subscribe(delegate : WundergroundInformationDelegate) {
        delegates.append(delegate)
    }
    
    func locationChanged(currentLocation : CoordinateLocation) {
        
        let success = { (dictionary : [String : Any]) -> Void in
            self.parseFeatureResponses(dictionary: dictionary)
        }
        let failure = { (dictionary: String) -> Void in
            print(dictionary)
        }
        
        let serviceString = formURLStringRequest(withFeatures: .geolookup, .conditions, useIpAddress: false)
        retrieveData(serviceString: serviceString, success: success, failure: failure)
    }
    
    func parseFeatureResponses(dictionary : [String : Any]) {
        let responseDict = dictionary["response"] as! [String : Any]
        let responseFeatures = responseDict["features"] as! [String : Int]
        
        // If response contains geolookup, parse the information
        if responseFeatures[FeatureParams.geolookup.stringValue] == 1 {
            do {
                let location = try Location(withDict: dictionary["location"] as! [String : Any])
                print("Updated Location to ", location.city)
                notifyLocationInformationChanged(updatedLocation: location)
            } catch {
                print("Failed to create location out of response")
            }
        }
        
        // If response contains conditions, parse the information
        if responseFeatures[FeatureParams.conditions.stringValue] == 1 {
            do {
                let conditions = try CurrentObservation(withDict: dictionary["current_observation"] as! [String : Any])
                print("Conditions in the current location are ", conditions.weatherDescription)
//                notifyLocationInformationChanged(updatedLocation: location)
            } catch {
                print("Failed to create current observation out of response")
            }
        }
    }
    
    func retrieveData(serviceString : String, success: @escaping (Dictionary<String, Any>) -> Void, failure: @escaping (String) -> Void) {
        
//        if let cached = UserDefaults.standard.object(forKey: "cachedJSONTest") as? [String : Any] {
//            success(cached)
//            return
//        }
        
        Alamofire.request(serviceString, withMethod: .get)
            .validate()
            .responseData { response in
                
                guard let data = response.data, response.result.isSuccess == true else {
                    failure("fail")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [String : Any]
                    success(json)
                    UserDefaults.standard.set(json, forKey: "cachedJSONTest")
                } catch {
                    print("Error converting data to JSON object.")
                    failure("fail")
                }
        }
        
    }
    
    func formURLStringRequest(withFeatures features: FeatureParams..., useIpAddress : Bool) -> String {
        var urlWithParams = baseURL + apiKey + "/"
        
        // appends "/" to features
        let formattedFeatures = features.map({$0.stringValue + "/"})
        
        // removes any duplicate features
        let uniqueFeatures = Array(Set(formattedFeatures))
        
        for feature in uniqueFeatures {
            urlWithParams += feature
        }
        
        urlWithParams += "q/"
        
        if useIpAddress == false, let currentLocation = LocationServices.shared.getCurrentLocationCoordinateString() {
            urlWithParams += currentLocation
        } else {
            urlWithParams += "autoip/"
        }
        
        urlWithParams += ".json"
        
        return urlWithParams
    }
    
    private func notifyLocationInformationChanged(updatedLocation : Location) {
        for delegate in delegates {
            delegate.locationInformationUpdated(location: updatedLocation)
        }
    }
}

enum JSONParsingError: Error {
    case InvalidPayload
}
