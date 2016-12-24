//
//  WUUpdater.swift
//  Twilight
//
//  Created by Mark on 11/19/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import SwiftyJSON

class WUUpdater: NSObject {
    
    static let webService = WUWebService.shared

    static func update(withFeatures features: WUFeatureType...,
        withLocation location: CoordinateLocation?,
        success: @escaping (WUResponse) -> Void,
        failure: @escaping (WUError?) -> Void) {
        
        let request = WURequest(features: features, location: location)
        
        let retrievalSuccess = { (dictionary: JSON) in
            let response = WUResponse()
            response.parseFeatures(json: dictionary)
            success(response)
        }
        
        webService.retrieveData(request: request,
                                success: retrievalSuccess,
                                failure: failure)
    }
    
    static func updateAllFeatures(withLocation location: CoordinateLocation,
                               success: @escaping (WUResponse) -> Void,
                               failure: @escaping (WUError?) -> Void) {
        
        self.update(withFeatures: .geolookup, .conditions, .forecast,
                    withLocation: location,
                    success: success,
                    failure: failure)
    }
    
    static func autoComplete(searchString: String,
        success: @escaping (WUAutoCompleteResponse) -> Void,
        failure: @escaping (WUError?) -> Void) {
        
        let request = WUAutoCompleteRequest(partialString: searchString)
        
        let retrievalSuccess = { (dictionary: JSON) in
            let response = WUAutoCompleteResponse(withJson: dictionary)
            success(response)
        }
        
        webService.retrieveAutoComplete(request: request,
                                success: retrievalSuccess,
                                failure: failure)
    }
}
