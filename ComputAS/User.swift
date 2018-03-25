//
//  User.swift
//  ComputAS
//
//  Created by Daniel Turato on 12/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase

// User class where it takes all the inputted user info and stores in the db
class User {
     
    var userDict: NSDictionary?
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    let db = Firestore.firestore()
     
    let defaultValues = UserDefaults.standard
    

     init(userDict: NSDictionary) {
     
        self.userDict = userDict
        
        
    }
     
     // Sets the database info in UserDefaults for ease of access
     func updateUserDefaults() {
     
          self.defaultValues.set(self.userDict?.value(forKey: "id") as! Int, forKey: "userID")
          self.defaultValues.set(self.userDict?.value(forKey: "username") as! String, forKey: "username")
          self.defaultValues.set(self.userDict?.value(forKey: "email") as! String, forKey: "email")
          self.defaultValues.set(self.userDict?.value(forKey: "name") as! String, forKey: "name")
     
     }
     // Stores the profile picture in a cloud storage
     func storeProfilePicture(profilePicture: UIImage) {
     
          let storageRef = self.storage.reference().child("\(UserDefaults.standard.string(forKey: "userID") as! String).png")
          let imageData: NSData = UIImagePNGRepresentation(profilePicture)! as NSData
          
          UserDefaults.standard.set(imageData, forKey: "profileImage")
          
          if let uploadData = UIImagePNGRepresentation(profilePicture) {
          
               storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                    
                         print(error!)
                         return
                    
                    }
                    
                    
               })
          
          }
     
     }
    
}


