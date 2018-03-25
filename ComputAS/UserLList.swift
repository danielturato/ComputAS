//
//  UserLList.swift
//  ComputAS
//
//  Created by Daniel Turato on 06/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import Foundation

import UIKit
import Alamofire

class UserLList  {
    
    var users: [UserL]
    
    init(users: [UserL]) {
        
        self.users = users
        
    }
    // Returns a list of all users
    class func getUserList() -> [UserLList] {
        
        return [allUsers()]
        
    }
    // Sets the list of all users w/ their info
    private class func allUsers() -> UserLList {
        self.saveUsers()
        
        guard let usersData = UserDefaults.standard.object(forKey: "allUsers") as? NSData else {
            
            return UserLList(users: [UserL]())
            
        }
        guard let users = NSKeyedUnarchiver.unarchiveObject(with: usersData as Data) as? [UserL] else {
            
            return UserLList(users: [UserL]())
        }

        return UserLList(users: users)
    }
    
    // This function grabs every user in the db and saves their info , ready to be displayed on the leaderboard
    class func saveUsers() {
        
        // GET request to get all users with their info
        let URL_GET_USERS_LEADER = "http://138.68.169.191/ComputAS/v1/leaderboardranking.php"
        
        
        Alamofire.request(URL_GET_USERS_LEADER, method: .get).responseJSON { (response) in
            
        
            if let result = response.result.value {
                
                var usersArray = [UserL]()
                
                let jsonData = result as! NSDictionary
                let users: NSArray = jsonData["users"] as! NSArray
                
                for user in users {
                    
                    let dictusers = user as! NSDictionary
                    let ranking = dictusers["ranking"] as! Int
                    let userID = dictusers["id"] as! Int
                    let username = dictusers["username"] as! String
                    let score = dictusers["score"] as! Int
                    
                    let tempUser = UserL(ranking: ranking, id: userID, username: username, score: score)
                    usersArray.append(tempUser)
                    
                }
                // Saves the data in userdefaults for later access
                let usersData = NSKeyedArchiver.archivedData(withRootObject: usersArray)
                UserDefaults.standard.set(usersData, forKey: "allUsers")
                
            }
            
            
        }
        
        
    }
}
