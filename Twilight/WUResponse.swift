//
//  WUResponse.swift
//  Twilight
//
//  Created by Mark on 12/11/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit


class WUResponse: NSObject {
    var location: Location?
    var conditions: CurrentObservation?
    // future response types go here
    
    override init() {
        
    }
    
    func parseFeatures(json: [String: Any]) {
        let responseDict = json["response"] as! [String : Any]
        let responseFeatures = responseDict["features"] as! [String : Int]
        
        // If response contains geolookup, parse the information
        if responseFeatures[WUFeatureType.geolookup.stringValue] == 1 {
            parseLocation(response: json)
        }
        
        if responseFeatures[WUFeatureType.conditions.stringValue] == 1 {
            parseConditions(response: json)
        }
    }
    
    private func parseLocation(response: [String: Any]) {
        do {
            location = try Location(withDict: response["location"] as! [String : Any])
        } catch let error as SerializationError {
            log.error(error.localizedDescription)
        } catch {
            log.error("Unknown Error parsing Location object.")
        }
    }
    
    private func parseConditions(response: [String: Any]) {
        do {
            conditions = try CurrentObservation(withDict: response["current_observation"] as! [String : Any])
        } catch let error as SerializationError {
            log.error(error.localizedDescription)
        } catch {
            log.error("Unknown Error parsing Conditions object.")
        }
    }
}
