//
//  NotificationsTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 14/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

class NotificationsTableViewController: UITableViewController {
    
    var friendRequests = FriendRequests.getFriendRequests()[0].friendRequests

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestTableViewCell
        let friendRequest = friendRequests[indexPath.row]
        
        cell.request = friendRequest
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let decline = UITableViewRowAction(style: .destructive, title: "Decline") { (action, indexPath) in
            
            let parameters: Parameters = [
            
                "action" : "declined",
                "frid": self.friendRequests[indexPath.row].id,
                "userIdOne": self.friendRequests[indexPath.row].userIdOne,
                "userIdTwo": UserDefaults.standard.integer(forKey: "userID")
            
            ]
            self.removeRequest(parameters: parameters)
            
            self.friendRequests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
        let accept = UITableViewRowAction(style: .destructive, title: "Accept") { (action, indexPatb) in
            
            let parameters: Parameters = [
                
                "action" : "accept",
                "frid": self.friendRequests[indexPath.row].id,
                "userIdOne": self.friendRequests[indexPath.row].userIdOne,
                "userIdTwo": UserDefaults.standard.integer(forKey: "userID")
                
            ]
            self.removeRequest(parameters: parameters)
            
            self.friendRequests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
        decline.backgroundColor = UIColor(red: 0.91, green: 0.30, blue: 0.23, alpha: 1.0)
        accept.backgroundColor = UIColor(red: 0.10, green: 0.74, blue: 0.61, alpha: 1.0)
        
        return [decline, accept]
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor(red:0.01, green:0.66, blue:0.98, alpha:1.0)
        
        let image = UIImageView(image: #imageLiteral(resourceName: "icons8-school-director-35"))
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(image)
        
        let label = UILabel()
        label.text = "Friend Requests"
        label.frame = CGRect(x: 45, y:5, width: 150, height: 35)
        label.textColor = UIColor.white
        view.addSubview(label)
        
        return view
    }
    
    func removeRequest(parameters: Parameters) {
        
        let URL_REMOVE_REQUEST = "http://138.68.169.191/ComputAS/v1/friendrequestaction.php"
        
        Alamofire.request(URL_REMOVE_REQUEST, method: .post, parameters: parameters)
        
        
    }

   

}
