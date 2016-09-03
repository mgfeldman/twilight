//
//  ViewController.swift
//  Crepuscular
//
//  Created by Mark on 8/25/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, WundergroundInformationDelegate {

    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("loaded")
        WundergroundWebService.shared.subscribe(delegate: self)

    }
    
    func success (dictionary: Dictionary<String, Any>) -> Void {
        let responseDict = dictionary["response"] as! [String : Any]
        let responseFeatures = responseDict["features"] as! [String : Int]
        
        if responseFeatures[FeatureParams.geolookup.stringValue]  == 1 {
            do {
                let location = try Location(withDict: dictionary["location"] as! [String : Any])
                updateView(location: location)
            } catch {

            }
        }
        
    }
    let failure = { (dictionary: String) -> Void in
        print(dictionary)
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
        
//        let service = WundergroundWebService.shared.formURLStringRequest(withFeatures: .geolookup, useIpAddress: false)
        LocationServices.shared.getLocation()
//        WundergroundWebService.shared.retrieveData(serviceString: service, success: success, failure: failure)
    }
    
}

