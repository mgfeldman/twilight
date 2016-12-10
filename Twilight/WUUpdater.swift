//
//  WUUpdater.swift
//  Twilight
//
//  Created by Mark on 11/19/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

class WUUpdater: NSObject {
    
    static let webService = WundergroundWebService.shared

    static func update(withFeatures features: WUFeatureType...,
        withLocation location: CoordinateLocation?,
        success: @escaping ([String : Any]) -> Void,
        failure: @escaping (Error?) -> Void) {
        
        let request = WURequest(features: features, location: location)
        
        webService.retrieveData(request: request,
                                success: success,
                                failure: failure)
    }
    
    static func updateGeoLookup(withLocation location: CoordinateLocation,
                         success: @escaping ([String : Any]) -> Void,
                         failure: @escaping (Error?) -> Void) {
        
        self.update(withFeatures: .geolookup,
                    withLocation: location,
                    success: success,
                    failure: failure)
    }
    
    static func updateConditions(withLocation location: CoordinateLocation,
                          success: @escaping ([String : Any]) -> Void,
                          failure: @escaping (Error?) -> Void) {
        
        self.update(withFeatures: .conditions,
                    withLocation: location,
                    success: success,
                    failure: failure)
    }
    
    static func updateForecast(withLocation location: CoordinateLocation,
                        success: @escaping ([String : Any]) -> Void,
                        failure: @escaping (Error?) -> Void) {
        
        self.update(withFeatures: .forecast,
                    withLocation: location,
                    success: success,
                    failure: failure)
    }
}
