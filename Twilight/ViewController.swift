//
//  ViewController.swift
//  Crepuscular
//
//  Created by Mark on 8/25/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WUInformationDelegate {

    @IBOutlet weak var observationLocation: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        WundergroundWebService.shared.subscribe(delegate: self)
    }
    
    func updateView(location : Location) {
        DispatchQueue.main.async {
            self.cityLabel.text = location.city + ", " + location.state
        }
    }
    
    func locationInformationUpdated(location: Location) {
        updateView(location: location)
    }
    
    func conditionsInformationUpdated(conditions: CurrentObservation) {
        DispatchQueue.main.async {
            self.currentTemperatureLabel.text = conditions.displayableWeatherString
            self.observationLocation.text = conditions.observationLocation.city
            self.descriptionLabel.text = conditions.weatherDescription
        }
    }
    
    @IBAction func btnPressed(_ sender: AnyObject) {
        
        LocationServices.shared.getLocation()
    }
    
}

