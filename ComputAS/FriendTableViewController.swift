//
//  FriendTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 06/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

class FriendTableViewController: UITableViewController {
    
    // Grabs the list of friends
    var friends = FriendsList.getFriendList()[0].friends
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFriends), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        
    }
    
    @objc func refreshFriends() {
        
        friends = FriendsList.getFriendList()[0].friends
        tableView.reloadData()
        refreshControl?.endRefreshing()
        
    }
    
    // Sets the number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Will create (friends count) of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    // Sets each row for each friend in users friends
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell
        let friend = friends[indexPath.row]
        
        cell.friend = friend
        
        return cell
    }
    // Allows the user to delete any of their friends
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let unfriend = UITableViewRowAction(style: .destructive, title: "Unfriend") { (action, indexPath) in
            
            let parameters: Parameters = [
            
                "userIdOne": UserDefaults.standard.integer(forKey: "userID"),
                "userIdTwo" : self.friends[indexPath.row].id
            
            ]
            // POST request to the delete a friend
            let URL_DELETE_FRIEND = "http://138.68.169.191/ComputAS/v1/deletefriend.php"
            
            Alamofire.request(URL_DELETE_FRIEND, method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
                
                self.friends.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                
            })
            
            UserDefaults.standard.removeObject(forKey: "\(self.friends[indexPath.row].username)-pic")
        }
        
        unfriend.backgroundColor = UIColor(red: 0.91, green: 0.30, blue: 0.23, alpha: 1.0)
        
        return [unfriend]
    }
    
    var selectedFriend: Friend?
    // View each friends profile
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let friend = friends[indexPath.row]
        
        selectedFriend = friend
        
        performSegue(withIdentifier: "showFriendDetail", sender: nil)
        
    }
    // WIll send that friends info to over views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showFriendDetail" {
        
            let friendDetailVC = segue.destination as! FriendDetailViewController
            
            friendDetailVC.friend = selectedFriend
        
        }
        
    }
}
