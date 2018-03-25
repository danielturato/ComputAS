//
//  ClassUserTableViewCell.swift
//  ComputAS
//
//  Created by Daniel Turato on 03/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase

class ClassUserTableViewCell: UITableViewCell {

    // Outlets connecting to the view
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    // Requires the user to be set before displaying
    var user: ClassUser? {
        didSet { // If the user is set, this function will execute
            self.updateUI()
        }
    }
    
    // Used to uodate the UI
    func updateUI() {
        
        usernameLabel.text = user?.username
        
        let userID: Int = (user?.id)!
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let userImage = storageRef.child("\(userID).png")
    
        // Grabing the users profile picture from the cloud storage
        userImage.getData(maxSize: 11 * 1024 * 1024) { (data, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                
            } else {
                
                self.loadingView.stopAnimating()
                self.profilePictureImage.image = UIImage(data: data as! Data)!
                
                
            }
            
        }
        
        profilePictureImage?.layer.cornerRadius = (profilePictureImage?.frame.size.width)! / 2
        profilePictureImage?.layer.masksToBounds = true
        
    }
    
}
