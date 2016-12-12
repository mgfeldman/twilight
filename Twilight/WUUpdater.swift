//
//  WUUpdater.swift
//  Twilight
//
//  Created by Mark on 11/19/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

class WUUpdater: NSObject {
    
    static let webService = WUWebService.shared

    static func update(withFeatures features: WUFeatureType...,
        withLocation location: CoordinateLocation?,
        success: @escaping (WUResponse) -> Void,
        failure: @escaping (WUError?) -> Void) {
        
        let request = WURequest(features: features, location: location)
        
        let retrievalSuccess = { (dictionary: [String: Any]) in
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
        
        self.update(withFeatures: .geolookup, .conditions,
                    withLocation: location,
                    success: success,
                    failure: failure)
    }
}
