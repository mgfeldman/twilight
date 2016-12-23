//
//  WundergroundWebService.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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

class WUWebService: NSObject {
    static let shared = WUWebService()
    
    override init() {
        super.init()
    }

    func retrieveData(request: WURequest, success: @escaping (JSON) -> Void, failure: @escaping (WUError?) -> Void) {
        
        guard let requestString = request.requestString else {
            failure(WUError(withMessage: "WURequest missing requestString"))
            return
        }
        
        log.debug("Requesting from \(requestString)")

        Alamofire.request(requestString)
            .validate()
            .responseData { response in
                
                guard let data = response.data, response.result.isSuccess == true else {
                    failure(WUError(fromError: response.result.error))
                    return
                }
                
                let json = JSON(data: data)
                success(json)
        }
    }
    
    func retrieveAutoComplete(request: WUAutoCompleteRequest, success: @escaping (JSON) -> Void, failure: @escaping (WUError?) -> Void) {
        
        guard let requestString = request.requestString else {
            failure(WUError(withMessage: "WURequest missing requestString"))
            return
        }
        
        log.debug("Requesting from \(requestString)")
        
        Alamofire.request(requestString)
            .validate()
            .responseData { response in
                
                guard let data = response.data, response.result.isSuccess == true else {
                    failure(WUError(fromError: response.result.error))
                    return
                }
                
                let json = JSON(data: data)
                success(json)
        }
    }
}

class WUError: Error {
    var error: Error?
    var message: String
    
    init(withMessage message: String) {
        self.message = message
    }
    
    init(fromError error: Error?) {
        self.error = error
        if error != nil {
            self.message = error!.localizedDescription
        } else {
            self.message = "Unknown Error"
        }
    }
}
