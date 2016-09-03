//
//  ViewController.swift
//  Crepuscular
//
//  Created by Mark on 8/25/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import Alamofire

public enum FeatureParams : String {
    case conditions    = "conditions"
    case geolookup     = "geolookup"
    case forecast      = "forecast"
    case alerts        = "alerts"
    case forecast10day = "forecast10day"
    case history       = "history"
    case hourly        = "hourly"
    case hourly10day   = "hourly10day"
    case planner       = "planner"
    case rawtide       = "rawtide"
    case tide          = "tide"
    case webcams       = "webcams"
    case yesterday     = "yesterday"
    
    var stringValue : String {
        return self.rawValue
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: locationChangedNotification.name, object: nil)
    }
    
    func success (dictionary: Dictionary<String, Any>) -> Void {
        let responseDict = dictionary["response"] as! [String : Any]
        let responseFeatures = responseDict["features"] as! [String : Int]
        
        if responseFeatures[FeatureParams.geolookup.description]  == 1 {
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
    @IBAction func btnPressed(_ sender: AnyObject) {
        
//        let service = WundergroundWebService.shared.formURLStringRequest(withFeatures: .geolookup, useIpAddress: false)
        LocationServices.shared.getLocation()
//        WundergroundWebService.shared.retrieveData(serviceString: service, success: success, failure: failure)
    }
    
}

