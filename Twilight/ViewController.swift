//
//  ViewController.swift
//  Crepuscular
//
//  Created by Mark on 8/25/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WundergroundInformationDelegate {

    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WundergroundWebService.shared.subscribe(delegate: self)
    }
    
    func updateView(location : Location) {
        DispatchQueue.main.async {
            self.cityLabel.text = location.city
            self.countryLabel.text = location.country
            self.zipLabel.text = location.zip
        }
    }
    
    func locationInformationUpdated(location: Location) {
        updateView(location: location)
    }
    
    @IBAction func btnPressed(_ sender: AnyObject) {
        
        LocationServices.shared.getLocation()
    }
    
}

