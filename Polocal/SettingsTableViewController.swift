//
//  SettingsTableViewController.swift
//  Polocal
//
//  Created by Adam Eliezerov on 15/10/2018.
//  Copyright © 2018 Adam Eliezerov. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if indexPath.section == 0 && indexPath.row == 0 {
			print("report")
			// doesn't do anything currently...
		} else if indexPath.section == 1 && indexPath.row == 0 {
			print("rate")
			// doesn't do anything currently...
		}
		
	}


}
