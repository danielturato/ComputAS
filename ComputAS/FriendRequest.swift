//
//  FriendRequest.swift
//  ComputAS
//
//  Created by Daniel Turato on 13/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

class FriendRequest: NSObject, NSCoding {
    
    var profilePicture: UIImage
    var id: Int
    var username: String
    var fullName: String
    var userIdOne: Int
    
    // Constructor which builds the class
    init(id: Int, username: String, fullName: String, userId: Int, profilePicture: UIImage) {
        
        self.id = id
        self.username = username
        self.fullName = fullName
        self.userIdOne = userId
        self.profilePicture = profilePicture
        
    }
    
    
    // The functions below are defualt in conforming to NSObject & NSCoding which allows me to save arrays of objects locally
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
        self.fullName = aDecoder.decodeObject(forKey: "fullName") as? String ?? ""
        self.userIdOne = aDecoder.decodeInteger(forKey: "userIdOne")
        self.profilePicture = (aDecoder.decodeObject(forKey: "profilePicture") as? UIImage)!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(fullName, forKey: "fullName")
        aCoder.encode(userIdOne, forKey: "userIdOne")
        aCoder.encode(profilePicture, forKey: "profilePicture")
    }
    
    
}
