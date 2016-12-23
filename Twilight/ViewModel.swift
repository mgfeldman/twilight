//
//  ViewModel.swift
//  Twilight
//
//  Created by Mark on 12/19/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

class ViewModel: NSObject, LocationServicesDelegate {
    var reloadViewCallback : (()->())!
    var location: Location?
    var conditions: CurrentObservation?
    var forecast: Forecast?
    
    var locationService: LocationServices!

    init(reloadViewCallback : @escaping (()->())) {
        
        super.init()
        
        locationService = LocationServices(withObserver: self)
//        locationService.getLocation()
        
        self.reloadViewCallback = reloadViewCallback
    }
    
    //invoke data manager to get new data
    func retrieveData(location: CoordinateLocation){
        
        WUUpdater.updateAllFeatures(withLocation: location, success: { (response) in
            self.location = response.location
            self.conditions = response.conditions
            self.forecast = response.forecast
            
            self.reloadViewCallback()
        }, failure: { (error) in
            
        })
    }
    
    func locationChanged(currentLocation: CoordinateLocation) {
        retrieveData(location: currentLocation)
    }
    
    func getStationsCount() -> Int {
        return location?.nearbyWeatherStations.count ?? 0
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func setUpTableViewCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
        
        let station = location?.nearbyWeatherStations[indexPath.row]
        cell.configure(station: station!)
        
        return cell
    }
    
    func selectedRowAt(indexPath: IndexPath) {
        
        if let selectedStation = self.location?.nearbyWeatherStations[indexPath.row] {
            let location = CoordinateLocation(latitude: selectedStation.coordinates.latitude!,
                                          longitude: selectedStation.coordinates.longitude!)
        
            retrieveData(location: location)
        }
    }
}
