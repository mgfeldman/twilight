//
//  ViewController.swift
//  Crepuscular
//
//  Created by Mark on 8/25/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
}
class ViewController: UIViewController, LocationServicesDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var stationsTableView: UITableView!
    @IBOutlet weak var observationLocation: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var locationService: LocationServices?
    var stations = [WeatherStation]() {
        didSet {
            DispatchQueue.main.async {
                self.stationsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService = LocationServices(withObserver: self)
        locationService?.getLocation()
        stationsTableView.delegate = self
        stationsTableView.dataSource = self
    }
    
    func updateView(location : Location, conditions: CurrentObservation) {
        stations = location.nearbyWeatherStations
        DispatchQueue.main.async {
            self.cityLabel.text = location.city + ", " + location.state
            self.currentTemperatureLabel.text = conditions.displayableWeatherString
        }
    }
    
    func locationChanged(currentLocation: CoordinateLocation) {
        WUUpdater.updateAllFeatures(withLocation: currentLocation,
        success: { (response) -> Void in
            self.updateView(location: response.location!, conditions: response.conditions!)
        }, failure: {(error: WUError?) -> Void in
            let alertController = UIAlertController(title: "Error", message: error?.message, preferredStyle:
                    UIAlertControllerStyle.alert)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    @IBAction func btnPressed(_ sender: AnyObject) {
        
        locationService!.getLocation()
    }
    
    //MARK: UITableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
        
        let station = stations[indexPath.row]
        
        switch station {
        case is AirportWeatherStation:
            cell.label1.text = (station as! AirportWeatherStation).icao
            cell.label2.text = ""
            break
        case is PersonalWeatherStation:
            cell.label1.text = (station as! PersonalWeatherStation).neighborhood
            cell.label2.text = String((station as! PersonalWeatherStation).id)
            break
        default:
            break
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedStation = stations[indexPath.row]
        let location = CoordinateLocation(latitude: selectedStation.coordinates.latitude!,
                                          longitude: selectedStation.coordinates.longitude!)
        WUUpdater.updateAllFeatures(withLocation: location,
                                    success: { (response) -> Void in
                                        self.updateView(location: response.location!, conditions: response.conditions!)
        }, failure: {(error: WUError?) -> Void in
            let alertController = UIAlertController(title: "Error", message: error?.message, preferredStyle:
                UIAlertControllerStyle.alert)
            self.present(alertController, animated: true, completion: nil)
        })
    }
}

