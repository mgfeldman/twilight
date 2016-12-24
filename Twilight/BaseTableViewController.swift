/*
Copyright (C) 2016 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
Base or common view controller to share a common UITableViewCell prototype between subclasses.
*/

import UIKit

class BaseTableViewController: UITableViewController {
    
    static let nibName = "TableCell"
    static let tableViewCellIdentifier = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseTableViewController.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: BaseTableViewController.tableViewCellIdentifier)
        tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7468278104)
        self.tableView.tableFooterView = UIView()

    }
    
    func configureCell(_ cell: UITableViewCell, forResult result: WUAutoCompleteResult) {
        cell.textLabel?.text = result.name
    }
}
