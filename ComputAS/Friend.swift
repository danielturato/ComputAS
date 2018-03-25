//
//  Friend.swift
//  ComputAS
//
//  Created by Daniel Turato on 02/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase

class Friend: NSObject, NSCoding {

    var friendID: Int
    var profilePicture: UIImage
    var id: Int
    var username: String
    var fullName: String
    var score: Int
    
    // Constructor which builds the class
    init(id: Int, username: String, fullName: String, score: Int, profilePicture: UIImage, friendID: Int) {
        
        self.id = id
        self.username = username
        self.fullName = fullName
        self.score = score
        self.profilePicture = profilePicture
        self.friendID = friendID
        
    }
    
    
    // The functions below are defualt in conforming to NSObject & NSCoding which allows me to save arrays of objects locally
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
        self.fullName = aDecoder.decodeObject(forKey: "fullName") as? String ?? ""
        self.score = aDecoder.decodeInteger(forKey: "score")
        self.friendID = aDecoder.decodeInteger(forKey: "friendID")
        self.profilePicture = (aDecoder.decodeObject(forKey: "profilePicture") as? UIImage)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(friendID, forKey: "friendID")
        aCoder.encode(profilePicture, forKey: "profilePicture")
    }


}

