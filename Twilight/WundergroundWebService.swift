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
        let failure = { (error: Error?) -> Void in
            log.error(error ?? "No error provided")
        }
        
        WUUpdater.update(withFeatures: .geolookup, .conditions,
               withLocation: currentLocation,
               success: success,
               failure: failure)
    }
    
    fileprivate func parseFeatureResponses(dictionary : [String : Any]) {
        let responseDict = dictionary["response"] as! [String : Any]
        let responseFeatures = responseDict["features"] as! [String : Int]
        
        // If response contains geolookup, parse the information
        if hasGeoLookup(dictionary: responseFeatures) == true {
            do {
                let location = try Location(withDict: dictionary["location"] as! [String : Any])
                log.info("Updated Location to \(location.city), \(location.countryName)")
                notifyLocationInformationChanged(updatedLocation: location)
            } catch {
                log.error("Failed to create Location out of response.")
            }
        }
        
        // If response contains conditions, parse the information
        if responseFeatures[WUFeatureType.conditions.stringValue] == 1 {
            do {
                let conditions = try CurrentObservation(withDict: dictionary["current_observation"] as! [String : Any])
                log.info("Conditions in the current location are \(conditions.weatherDescription)")
                notifyConditionsInformationChanged(condition: conditions)
            } catch {
                log.error("Failed to create Current Observation out of response.")
            }
        }
    }
    
    func retrieveData(request: WURequest, success: @escaping ([String: Any]) -> Void, failure: @escaping (Error?) -> Void) {
        
//        if let cached = UserDefaults.standard.object(forKey: "cachedJSONTest") as? [String : Any] {
//            success(cached)
//            return
//        }
        
        guard let requestString = request.requestString else {
            failure(nil)
            return
        }
        
        log.debug("Requesting from \(requestString)")

        Alamofire.request(requestString)
            .validate()
            .responseData { response in
                
                guard let data = response.data, response.result.isSuccess == true else {
                    failure(response.result.error)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [String : Any]
                    success(json)
                    UserDefaults.standard.set(json, forKey: "cachedJSONTest")
                } catch {
                    log.error("Error converting data to JSON object.")
                    failure(response.result.error)
                }
        }
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
    
    fileprivate func hasGeoLookup(dictionary: [String: Int]) -> Bool {
        return dictionary[WUFeatureType.geolookup.stringValue] == 1
    }
    
}

public struct WURequest {
    let apiKey = "005ecab154b1d3ca"
    let baseURL = "http://api.wunderground.com/api/"
    var features: [WUFeatureType]
    private var useIpAddress: Bool
    var location: CoordinateLocation?
    var requestString: String? {
        get {
            return formURLStringRequest()
        }
    }
    
    init(features: [WUFeatureType], location: CoordinateLocation?) {
        self.features = features
        self.location = location
        if location == nil {
            self.useIpAddress = true
        } else {
            self.useIpAddress = false
        }
    }
    
    private func formURLStringRequest() -> String? {
        
        guard (useIpAddress == true || location?.coordinateString != nil) &&
            features.isEmpty == false else {
                return nil
        }
        
        var urlWithParams = baseURL + apiKey + "/"
        
        // appends "/" to features and removes any duplicate features
        let formattedFeatures = Array(Set(features.map({$0.stringValue + "/"})))
        
        for feature in formattedFeatures {
            urlWithParams += feature
        }
        
        urlWithParams += "q/"
        
        if useIpAddress == false {
            urlWithParams += location!.coordinateString!
        } else {
            urlWithParams += "autoip/"
        }
        
        urlWithParams += ".json"
        
        return urlWithParams
    }
}
