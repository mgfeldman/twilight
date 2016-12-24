/*
Copyright (C) 2016 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The table view controller responsible for displaying the filtered products as the user types in the search field.
*/

import UIKit

class SearchResultsTableController: BaseTableViewController {
    
    // MARK: - Properties
    
    var filteredResults = [WUAutoCompleteResult]()
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier)!
        let result = filteredResults[indexPath.row]
        configureCell(cell, forResult: result)
        
        return cell
    }
}
