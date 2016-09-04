//
//  CoordinateLocation.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

struct CoordinateLocation {
    var latitude : String?
    var longitude : String?
    var elevation : String?
    var coordinateString : String? {
        get {
            if self.latitude == nil || self.longitude == nil {
                return nil
            }
            return latitude! + "," +  longitude!
        }
    }
    
    init(latitude : String, longitude : String, elevation : String? = .none) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
    }
    
    init(coordinateString: String) {
        
        let crdSplit = coordinateString.characters.split(separator: ",")
        latitude = String(crdSplit.first!)
        longitude = String(crdSplit.last!)
    }
}
