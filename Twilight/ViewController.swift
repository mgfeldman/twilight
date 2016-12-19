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
class ViewController: UIViewController {

    @IBOutlet weak var navbarLabel2: UILabel!
    @IBOutlet weak var navbarLabel1: UILabel!
    @IBOutlet var navbarView: UIView!
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
    var navbarLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:400, height:50))
    var currentLocation: Location?
    var currentObservation: CurrentObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationService = LocationServices(withObserver: self)
        locationService?.getLocation()
        stationsTableView.delegate = self
        stationsTableView.dataSource = self
        
//        let navBarFrame = self.navigationController?.navigationItem.titleView?.frame
        
//        navbarLabel = UILabel(frame: CGRect(x:0, y:0, width:400, height:50))
//        navbarLabel.backgroundColor = UIColor.clear
//        navbarLabel.numberOfLines = 2
//        navbarLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
//        navbarLabel.textAlignment = .center
//        navbarLabel.textColor = UIColor.white
        
        self.navigationItem.titleView = navbarView

        
        
    }
    
    func updateNavigationBar(location: Location, conditions: CurrentObservation) {
//        navbarLabel.text = "\(location.city)\n11:07pm"
        navbarLabel1.text = conditions.observationLocation.city
        navbarLabel2.text = conditions.observationTime.replacingOccurrences(of: "Last Updated on", with: "")
    }
    
    func updateView(location : Location, conditions: CurrentObservation) {
        DispatchQueue.main.async {
            self.cityLabel.text = location.city + ", " + location.state
            self.currentTemperatureLabel.text = conditions.displayableWeatherString
        }
    }
    
    func updateStationsTableView(stations: [WeatherStation]?) {
        if let stations = stations {
            self.stations = stations
        }
    }

}

extension ViewController: LocationServicesDelegate {
    
    func locationChanged(currentLocation: CoordinateLocation) {
        WUUpdater.updateAllFeatures(withLocation: currentLocation,
        success: { (response) -> Void in
            self.updateView(location: response.location!, conditions: response.conditions!)
            self.updateStationsTableView(stations: response.location?.nearbyWeatherStations)
            self.updateNavigationBar(location: response.location!, conditions: response.conditions!)
        }, failure: {(error: WUError?) -> Void in
            let alertController = UIAlertController(title: "Error", message: error?.message, preferredStyle:
                UIAlertControllerStyle.alert)
            self.present(alertController, animated: true, completion: nil)
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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

extension UIImageView {
    
    func setGradientFor(dominantColor: UIColor, lightColor: UIColor, alpha: CGFloat) {
        
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        
        gradient.colors = [dominantColor.cgColor, lightColor.cgColor]
        
        UIGraphicsBeginImageContext(gradient.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradient.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image = image
    }
    
    func setBlackGradient(alpha: CGFloat) {
        self.setGradientFor(dominantColor: .black, lightColor: .clear, alpha: alpha)
    }
}
