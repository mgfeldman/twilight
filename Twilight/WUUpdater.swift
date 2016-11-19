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
    let apiKey = "005ecab154b1d3ca"
    let baseURL = "http://api.wunderground.com/api/"

    static func update(withFeatures features: WUFeatureType...,
        useIpAddress: Bool,
        success: @escaping ([String : Any]) -> Void,
        failure: @escaping (String) -> Void) {
        let serviceString = webService.formURLStringRequest(withFeatures: features,
                                                            useIpAddress: useIpAddress)
        webService.retrieveData(serviceString: serviceString, success: success, failure: failure)
    }
    
    static func updateGeoLookup(useIpAddress: Bool,
                         success: @escaping ([String : Any]) -> Void,
                         failure: @escaping (String) -> Void) {
        let serviceString = webService.formURLStringRequest(withFeatures: [.geolookup],
                                                             useIpAddress: useIpAddress)
        webService.retrieveData(serviceString: serviceString, success: success, failure: failure)
    }
    
    static func updateConditions(useIpAddress: Bool,
                          success: @escaping ([String : Any]) -> Void,
                          failure: @escaping (String) -> Void) {
        let serviceString = webService.formURLStringRequest(withFeatures: [.conditions],
                                                            useIpAddress: useIpAddress)
        webService.retrieveData(serviceString: serviceString, success: success, failure: failure)
    }
    
    static func updateForecast(useIpAddress: Bool,
                        success: @escaping ([String : Any]) -> Void,
                        failure: @escaping (String) -> Void) {
        let serviceString = webService.formURLStringRequest(withFeatures: [.forecast],
                                                            useIpAddress: useIpAddress)
        webService.retrieveData(serviceString: serviceString, success: success, failure: failure)
    }
}
