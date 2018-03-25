//
//  AddFriendTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 18/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

class AddFriendTableViewController: UITableViewController, UISearchBarDelegate, AddUserTableViewCellDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users = UserLList.getUserList()[0].users

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        
    }
    
    private func setUpSearchBar() {
        
        searchBar.delegate = self
        
    }
    
    // A search bar which will search through all the users in the db
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            
            users = UserLList.getUserList()[0].users
            self.tableView.reloadData()
            
        } else {
        
            users = users.filter { (UserL) -> Bool in
            return UserL.username.lowercased().contains(searchText.lowercased())
            }
            self.tableView.reloadData()
        }
        
    }
    // The number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // The number of rows per section in a table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // Identifies what each cell is and what the cells in the table need to be
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! AddUserTableViewCell
        let user = users[indexPath.row]
        
        cell.user = user
        cell.delegate = self
        
        return cell
        
    }
    // Cancels the select action on cells
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return nil
    }
    
    // When the user decides to add a user and clickes the add button
    var selectedUser: UserL?
    func addUserTableViewCellDidTapAddFriend(user: UserL) {
        
        selectedUser = user
        let URL_SEND_FRQ = "http://138.68.169.191/ComputAS/v1/sendfrrequest.php"
        
        let parameters: Parameters = [
            
            "userIdOne" : UserDefaults.standard.integer(forKey: "userID"),
            "userIdTwo" : user.id
            
        ]
        
        Alamofire.request(URL_SEND_FRQ, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                if jsonData["error"] as! Bool == false {
                    
                    // Show sent friend request screen
                    self.performSegue(withIdentifier: "friendRequestSent", sender: nil)
                    
                } else {
                    
                    // Show error screen
                    self.performSegue(withIdentifier: "errorFriendRequest", sender: nil)
                    
                }
                
            }
            
        }
        
    }
    
    
    // Preparing for a suspected segue, feeding it information before being sent
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "friendRequestSent" {
            
            let friendHomeVC = segue.destination as! FriendViewController
            
            friendHomeVC.requestUser = selectedUser
            friendHomeVC.requestMessage = "sent"
            
        } else if segue.identifier == "errorFriendRequest" {
            
            let friendHomeVC = segue.destination as! FriendViewController
            
            friendHomeVC.requestMessage = "error"
            
        }
        
    }
    
    
    
    

}
