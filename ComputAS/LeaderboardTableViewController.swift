//
//  LeaderboardTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 06/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {
    
    // Grabs users from the data models
    var users = UserLList.getUserList()[0].users
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows user to pull and refresh the page to update the info displayed
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshUsers), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        
    }
    // This function is called when the refresh action occurs
    @objc func refreshUsers() {
        
        users = UserLList.getUserList()[0].users
        tableView.reloadData()
        refreshControl?.endRefreshing()
        
    }
    // The number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Makes total amount of cells = to amount of users
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    // Assigns a user to each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        
        cell.user = user
        
        return cell
    }
    // Makes the cells not able to be selected
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return nil
        
    }
    
    


}
