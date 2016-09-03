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

// TODO: Why is this so complicated?
let locationChangedNotification = Notification(name: Notification.Name(rawValue: "locationChanged"))

class LocationServices: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationServices()
    private var currentLocation : CoordinateLocation? {
        didSet {
            NotificationCenter.default.post(locationChangedNotification)
        }
    }
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.requestAlwaysAuthorization()
        _ = WundergroundWebService.shared
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
        }
    }
    
    func getCurrentLocationCoordinateString() -> String? {
        return currentLocation?.coordinateString
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        let locValue : CLLocationCoordinate2D = location.coordinate
        currentLocation = CoordinateLocation(latitude: String(locValue.latitude), longitude: String(locValue.longitude))
        // when the current location is deemed "different" enough, send a notifcation of some sort
        // to have retrieveData go again
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func getLocation() {
        
        _ = SwiftLocation.Location.getLocation(withAccuracy: .block, frequency: .byDistanceIntervals(meters: 5.0), timeout: 50, onSuccess: { (location) in
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print("** Updated Location")
            self.currentLocation = CoordinateLocation(latitude: String(latitude), longitude: String(longitude))
        }) { (lastValidLocation, error) in
            print("Error occurred getting location: \(error.description)")
            if let location = lastValidLocation {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                self.currentLocation = CoordinateLocation(latitude: String(latitude), longitude: String(longitude))
            }
        }
    }
}

