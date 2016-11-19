//
//  WundergroundWebService.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import Alamofire

public enum WUFeatureType : String {
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
protocol WUInformationDelegate {
    func locationInformationUpdated(location : Location)
    func conditionsInformationUpdated(conditions : CurrentObservation)
}

class WundergroundWebService: NSObject, LocationServicesDelegate {
    static let shared = WundergroundWebService()
    let apiKey = "005ecab154b1d3ca"
    let baseURL = "http://api.wunderground.com/api/"
    private var delegates = [WUInformationDelegate]()
    
    override init() {
        super.init()
        LocationServices.shared.subscribe(delegate: self)
    }
    
    deinit {
        delegates.removeAll()
    }
    
    func subscribe(delegate : WUInformationDelegate) {
        delegates.append(delegate)
    }
    
    func locationChanged(currentLocation : CoordinateLocation) {
        
        let success = { (dictionary : [String : Any]) -> Void in
            self.parseFeatureResponses(dictionary: dictionary)
        }
        let failure = { (dictionary: String) -> Void in
            print(dictionary)
        }
        
        WUUpdater.update(withFeatures: .geolookup, .conditions,
               useIpAddress: true,
               success: success,
               failure: failure)
    }
    
    fileprivate func parseFeatureResponses(dictionary : [String : Any]) {
        let responseDict = dictionary["response"] as! [String : Any]
        let responseFeatures = responseDict["features"] as! [String : Int]
        
        // If response contains geolookup, parse the information
        if responseFeatures[WUFeatureType.geolookup.stringValue] == 1 {
            do {
                let location = try Location(withDict: dictionary["location"] as! [String : Any])
                print("Updated Location to ", location.city)
                notifyLocationInformationChanged(updatedLocation: location)
            } catch {
                print("Failed to create location out of response")
            }
        }
        
        // If response contains conditions, parse the information
        if responseFeatures[WUFeatureType.conditions.stringValue] == 1 {
            do {
                let conditions = try CurrentObservation(withDict: dictionary["current_observation"] as! [String : Any])
                print("Conditions in the current location are ", conditions.weatherDescription)
//                notifyLocationInformationChanged(updatedLocation: location)
                notifyConditionsInformationChanged(condition: conditions)
            } catch {
                print("Failed to create current observation out of response")
            }
        }
    }
    
    func retrieveData(serviceString : String, success: @escaping ([String: Any]) -> Void, failure: @escaping (String) -> Void) {
        
//        if let cached = UserDefaults.standard.object(forKey: "cachedJSONTest") as? [String : Any] {
//            success(cached)
//            return
//        }
        
        Alamofire.request(serviceString)
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
    
    func formURLStringRequest(withFeatures features: [WUFeatureType], useIpAddress : Bool) -> String {
        var urlWithParams = baseURL + apiKey + "/"

        // appends "/" to features and removes any duplicate features
        let formattedFeatures = Array(Set(features.map({$0.stringValue + "/"})))
        
        for feature in formattedFeatures {
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
    
    fileprivate func notifyLocationInformationChanged(updatedLocation : Location) {
        for delegate in delegates {
            delegate.locationInformationUpdated(location: updatedLocation)
        }
    }
    
    fileprivate func notifyConditionsInformationChanged(condition : CurrentObservation) {
        for delegate in delegates {
            delegate.conditionsInformationUpdated(conditions: condition)
        }
    }
}
