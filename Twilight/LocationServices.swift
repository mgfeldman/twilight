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
    
//    static let shared = LocationServices()
    var currentLocation : CoordinateLocation?
    let locationManager = CLLocationManager()
    var delegates = [LocationServicesDelegate]()
    var observer: LocationServicesDelegate
    
    init(withObserver observer: LocationServicesDelegate) {
        self.observer = observer
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
        }
//        setUpLocationTracking()
    }
    
    deinit {
        delegates.removeAll()
    }
    
    func subscribe(delegate : LocationServicesDelegate) {
        delegates.append(delegate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = manager.location else { return }
//        setCurrentLocation(location: location)
    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Getting location failed with error \(error.localizedDescription)")
//    }
    
    func getCurrentLocationCoordinateString() -> String? {
        return currentLocation?.coordinateString
    }
    
    func getLocation() {
//        locationManager.requestLocation()
        
        _ = SwiftLocation.Location.getLocation(withAccuracy: .block, frequency: .byDistanceIntervals(meters: 50.0), timeout: 50, onSuccess: { (location) in
            
            self.setCurrentLocation(location: location)
            
        }) { (lastValidLocation, error) in
            log.error("Error occurred getting location: \(error.description)")
            if lastValidLocation != nil {
                log.debug("Setting location to last valid location")
                self.setCurrentLocation(location: lastValidLocation!)
            }
        }
    }
    
    private func setCurrentLocation(location : CLLocation) {
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        if self.currentLocation != nil {
            self.currentLocation?.latitude = latitude
            self.currentLocation?.longitude = longitude
        } else {
            self.currentLocation = CoordinateLocation(latitude: latitude, longitude: longitude)
        }
        
//        self.notifyLocationChanged()
        observer.locationChanged(currentLocation: currentLocation!)
    }
    
    private func notifyLocationChanged() {
        for delegate in delegates {
            delegate.locationChanged(currentLocation: currentLocation!)
        }
    }
}

