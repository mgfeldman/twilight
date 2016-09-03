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

class LocationServices: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationServices()
    private var currentLocation : CoordinateLocation?
    
    let locationManager = CLLocationManager()
    var delegates = [LocationServicesDelegate]()
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
        }
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
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            self.currentLocation = CoordinateLocation(latitude: String(latitude), longitude: String(longitude))
            self.notifyLocationChanged()
            
        }) { (lastValidLocation, error) in
            print("Error occurred getting location: \(error.description)")
            if let location = lastValidLocation {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                self.currentLocation = CoordinateLocation(latitude: String(latitude), longitude: String(longitude))
            }
        }
    }
    
    private func notifyLocationChanged() {
        for delegate in delegates {
            delegate.locationChanged(currentLocation: currentLocation!)
        }
    }
}

