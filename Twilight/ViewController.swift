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
    
    func configure(station: WeatherStation) {
        switch station {
        case is AirportWeatherStation:
            label1.text = (station as! AirportWeatherStation).icao
            label2.text = ""
            break
        case is PersonalWeatherStation:
            label1.text = (station as! PersonalWeatherStation).neighborhood
            label2.text = String((station as! PersonalWeatherStation).id)
            break
        default:
            break
        }
    }
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

    var navbarLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:400, height:50))
    var currentLocation: Location? {
        get {
            return viewModel.location
        }
    }
    var currentObservation: CurrentObservation? {
        get {
            return viewModel.conditions
        }
    }
    
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stationsTableView.delegate = self
        stationsTableView.dataSource = self
        
        viewModel = ViewModel(reloadViewCallback: reloadTableViewData)
        self.navigationItem.titleView = navbarView
    }
    
    func reloadTableViewData() {
        DispatchQueue.main.async {
            self.stationsTableView.reloadData()
            self.updateView(location: self.currentLocation!, conditions: self.currentObservation!)
            self.updateNavigationBar(location: self.viewModel.location!, conditions: self.viewModel.conditions!)
        }
    }
    
    func updateNavigationBar(location: Location, conditions: CurrentObservation) {
        navbarLabel1.text = conditions.observationLocation.city
    }
    
    func updateView(location : Location, conditions: CurrentObservation) {
        DispatchQueue.main.async {
            self.cityLabel.text = location.city + ", " + location.state
            self.currentTemperatureLabel.text = conditions.displayableWeatherString
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return viewModel.setUpTableViewCell(indexPath: indexPath, tableView: tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.getStationsCount()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectedRowAt(indexPath: indexPath)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toSearch" {
//            if let searchVC = segue.destination as? UINavigationController {
//                for vc in searchVC.viewControllers {
//                    if let mainVC = vc as? MainTableViewController {
//                        mainVC.cities = (viewModel.location?.nearbyWeatherStations)!
//                    }
//                }
//            }
//        }
//    }
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
