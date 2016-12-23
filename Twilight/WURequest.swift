//
//  WURequest.swift
//  Twilight
//
//  Created by Mark on 12/11/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

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

public struct WUAutoCompleteRequest {
    
    let baseURL = "http://autocomplete.wunderground.com/aq?query="
    var requestString: String?
    
    init(partialString: String, countryCode: String? = nil) {
        requestString = baseURL + partialString.replacingOccurrences(of: " ", with: "%20")
        if let code = countryCode {
            requestString = requestString! + "&=\(code)"
        }
    }
}
