/*
Copyright (C) 2016 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
Base or common view controller to share a common UITableViewCell prototype between subclasses.
*/

import UIKit

class BaseTableViewController: UITableViewController {
    
    // MARK: - Types
    
    static let nibName = "TableCell"
    static let tableViewCellIdentifier = "cellID"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseTableViewController.nibName, bundle: nil)
        
        // Required if our subclasses are to use `dequeueReusableCellWithIdentifier(_:forIndexPath:)`.
        tableView.register(nib, forCellReuseIdentifier: BaseTableViewController.tableViewCellIdentifier)
    }
    
    // MARK: - Configuration
    
    func configureCell(_ cell: UITableViewCell, forResult result: WUAutoCompleteResult) {
        cell.textLabel?.text = result.city
        cell.detailTextLabel?.text = result.country
    }
}
