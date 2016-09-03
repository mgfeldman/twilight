//
//  WundergroundWebService.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import Alamofire

class WundergroundWebService: NSObject {
    static let shared = WundergroundWebService()
    let apiKey = "005ecab154b1d3ca"
    let baseURL = "http://api.wunderground.com/api/"
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: locationChangedNotification.name, object: nil)
    }
    
    func locationChanged() {
        
        let success = { (dictionary : [String : Any]) -> Void in
            self.parseFeatureResponses(dictionary: dictionary)
        }
        let failure = { (dictionary: String) -> Void in
            print(dictionary)
        }
        
        let serviceString = formURLStringRequest(withFeatures: .geolookup, useIpAddress: false)
        retrieveData(serviceString: serviceString, success: success, failure: failure)
    }
    
    func parseFeatureResponses(dictionary : [String : Any]) {
        let responseDict = dictionary["response"] as! [String : Any]
        let responseFeatures = responseDict["features"] as! [String : Int]
        if responseFeatures[FeatureParams.geolookup.stringValue] == 1 {
            do {
                let location = try Location(withDict: dictionary["location"] as! [String : Any])
                print("Updated Location to ", location.city)
            } catch {
                
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
}

enum JSONParsingError: Error {
    case InvalidPayload
}
