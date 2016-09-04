//
//  LocationServices.swift
//  Crepuscular
//
//  Created by Mark on 8/26/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftLocation

protocol LocationServicesDelegate {
    func locationChanged(currentLocation : CoordinateLocation)
}

class LocationServices: NSObject {
    
    static let shared = LocationServices()
    private var currentLocation : CoordinateLocation?
    
    let locationManager = CLLocationManager()
    var delegates = [LocationServicesDelegate]()
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
    }
    
    deinit {
        delegates.removeAll()
    }
    
    func subscribe(delegate : LocationServicesDelegate) {
        delegates.append(delegate)
    }
    
    func getCurrentLocationCoordinateString() -> String? {
        return currentLocation?.coordinateString
    }
    
    func getLocation() {
        
        _ = SwiftLocation.Location.getLocation(withAccuracy: .block, frequency: .byDistanceIntervals(meters: 5.0), timeout: 50, onSuccess: { (location) in
            
            self.setCurrentLocation(location: location)
            
        }) { (lastValidLocation, error) in
            print("Error occurred getting location: \(error.description)")
            self.setCurrentLocation(location: lastValidLocation)
        }
    }
    
    func setCurrentLocation(location : CLLocation?) {
        
        guard let loc = location else {
            return
        }
        
        let latitude = String(loc.coordinate.latitude)
        let longitude = String(loc.coordinate.longitude)
        
        if self.currentLocation != nil {
            self.currentLocation?.latitude = latitude
            self.currentLocation?.longitude = longitude
        } else {
            self.currentLocation = CoordinateLocation(latitude: latitude, longitude: longitude)
        }
        
        self.notifyLocationChanged()
    }
    
    private func notifyLocationChanged() {
        for delegate in delegates {
            delegate.locationChanged(currentLocation: currentLocation!)
        }
    }
}
