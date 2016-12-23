//
//  SearchViewModel.swift
//  Twilight
//
//  Created by Mark on 12/22/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {

    var reloadViewCallback : (()->())!
    var searchResults = WUAutoCompleteResponse()
    var filteredResults = WUAutoCompleteResponse()
    
    init(reloadViewCallback : @escaping (()->())) {
        
        super.init()
        self.reloadViewCallback = reloadViewCallback
    }
    
    func refreshData(searchString: String) {
        
        WUUpdater.autoComplete(searchString: searchString, success: { (response) in
            self.searchResults = response
            self.filteredResults = response
            self.reloadViewCallback()
        }, failure: { (error) in
            
        })
    }
    
    func clearData() {
        searchResults.results.removeAll()
        filteredResults.results.removeAll()
    }
    
    func numberOfRows() -> Int {
        return searchResults.results.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func setUpTableViewCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier, for: indexPath)
        let searchResult = searchResults.results[indexPath.row]
        cell.textLabel?.text = searchResult.city
        cell.detailTextLabel?.text = searchResult.country
        
        return cell
    }
    
//    func selectedRowAt(indexPath: IndexPath) {
//        
//        if let selectedStation = self.location?.nearbyWeatherStations[indexPath.row] {
//            let location = CoordinateLocation(latitude: selectedStation.coordinates.latitude!,
//                                              longitude: selectedStation.coordinates.longitude!)
//            
//            retrieveData(location: location)
//        }
//    }
    
    func updateSearchResults(for searchController: UISearchController) {
     
        let results = self.searchResults.results
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        // Build all the "AND" expressions for each value in the searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            
            var searchItemsPredicate = [NSPredicate]()
            
            // Below we use NSExpression represent expressions in our predicates.
            // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value).
            
            // Name field matching.
            let titleExpression = NSExpression(forKeyPath: "city")
            let searchStringExpression = NSExpression(forConstantValue: searchString)
            
            let titleSearchComparisonPredicate = NSComparisonPredicate(leftExpression: titleExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
            
            searchItemsPredicate.append(titleSearchComparisonPredicate)
            
            // Add this OR predicate to our master AND predicate.
            let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:searchItemsPredicate)
            
            return orMatchPredicate
        }
        
        // Match up the fields of the Product object.
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        filteredResults.results = results.filter { finalCompoundPredicate.evaluate(with: $0) }
        
        self.reloadViewCallback()

    }
}
