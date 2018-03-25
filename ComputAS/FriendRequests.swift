//
//  FriendRequests.swift
//  ComputAS
//
//  Created by Daniel Turato on 13/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class FriendRequests  {
    
    var friendRequests: [FriendRequest]
    
    init(friendRequests: [FriendRequest]) {
        
        self.friendRequests = friendRequests
        
    }
    // Returns a list of all a users friends
    class func getFriendRequests() -> [FriendRequests] {
        
        return [allRequests()]
        
    }
    // This function creates the friend list which is full of friend objects
    private class func allRequests() -> FriendRequests {
        self.saveRequests()
        
        guard let frqData = UserDefaults.standard.object(forKey: "allFriendRequests") as? NSData else {
            
            return FriendRequests(friendRequests: [FriendRequest]())
            
        }
        guard let requests = NSKeyedUnarchiver.unarchiveObject(with: frqData as! Data) as? [FriendRequest] else {
            
            return FriendRequests(friendRequests: [FriendRequest]())
        }
        
        return FriendRequests(friendRequests: requests)
    }
    
    // This function loops through each friend you have and creates a Friend object from the friend's information
    class func saveRequests() {
        
        // POST request to grab all friends of a user
        let URL_GET_REQUESTS = "http://138.68.169.191/ComputAS/v1/getfriendrequests.php"
        
        let parameters: Parameters = [
            
            "id" : UserDefaults.standard.integer(forKey: "userID")
            
        ]
        
        Alamofire.request(URL_GET_REQUESTS, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                var requestsArray = [FriendRequest]()
                
                let jsonData = result as! NSDictionary
                let requests: NSArray = jsonData["frqs"] as! NSArray
                
                for request in requests {
                    
                    let dictfrq = request as! NSDictionary
                    let id = dictfrq["id"] as! Int
                    let userID = dictfrq["userId"] as! Int
                    let username = dictfrq["username"] as! String
                    let name = dictfrq["name"] as! String
                    
                    let friendRequest = FriendRequest(id: id, username: username, fullName: name, userId: userID, profilePicture: UIImage())
                    
                    requestsArray.append(friendRequest)
                    
                   
                }
                
                let frqData = NSKeyedArchiver.archivedData(withRootObject: requestsArray)
                UserDefaults.standard.set(frqData, forKey: "allFriendRequests")
            }
        }
    }
    
    private class func createFriendRequest(dictfrq: [String: Any]) {
        
        let id = dictfrq["id"] as! Int
        let userID = dictfrq["userId"] as! Int
        
        let URL_GET_USER = "http://138.68.169.191/ComputAS/v1/getuserbyid.php"
        
        let parameters: Parameters = [
        
            "id": userID
        
        ]
        
        Alamofire.request(URL_GET_USER, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                let user = jsonData["user"] as! NSDictionary
                
                
                let friendRequest = FriendRequest(id: id, username: user["username"] as! String, fullName: user["name"] as! String, userId: userID, profilePicture: UIImage())
                
                
                
            }
            
        }
        
    
    }
    
}
