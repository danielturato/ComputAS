//
//  FriendsList.swift
//  ComputAS
//
//  Created by Daniel Turato on 02/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class FriendsList  {
    
    var friends: [Friend]
    
    init(friends: [Friend]) {
        
        self.friends = friends
        
    }
    // Returns a list of all a users friends
    class func getFriendList() -> [FriendsList] {
    
        return [allFriends()]
    
    }
    // This function creates the friend list which is full of friend objects
    private class func allFriends() -> FriendsList {
        self.saveFriends()

        guard let friendsData = UserDefaults.standard.object(forKey: "allFriends") as? NSData else {
        
            return FriendsList(friends: [Friend]())
        
        }
        guard let friends = NSKeyedUnarchiver.unarchiveObject(with: friendsData as! Data) as? [Friend] else {
            
            return FriendsList(friends: [Friend]())
        }
        
        return FriendsList(friends: friends)
    }
    
    // This function loops through each friend you have and creates a Friend object from the friend's information
    class func saveFriends() {
        
        // POST request to grab all friends of a user
        let URL_GET_FRIENDS = "http://138.68.169.191/ComputAS/v1/getfriends.php"
        
        let parameters: Parameters = [
            
            "userID" : UserDefaults.standard.integer(forKey: "userID") //13
            
        ]
        
        Alamofire.request(URL_GET_FRIENDS, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
            
                var friendsArray = [Friend]()
                
                let jsonData = result as! NSDictionary
                let friends: NSArray = jsonData["friends"] as! NSArray
                
                for friend in friends {
                
                    let dictfr = friend as! NSDictionary
                    let friendID = dictfr["id"] as! Int
                    let userID = dictfr["userIdTwo"] as! Int
                    let username = dictfr["username"] as! String
                    let name = dictfr["name"] as! String
                    let score = dictfr["score"] as! Int
                    
                    // Create an instance of Friend with new info
                    let tempFriend = Friend(id: userID, username: username, fullName: name, score: score, profilePicture: UIImage(), friendID: friendID)
                    friendsArray.append(tempFriend)
                    
                }
                // Store the data to be used in a different func
                let friendsData = NSKeyedArchiver.archivedData(withRootObject: friendsArray)
                UserDefaults.standard.set(friendsData, forKey: "allFriends")
            
        }

    }
}
}

