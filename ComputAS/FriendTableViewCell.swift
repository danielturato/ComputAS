//
//  FriendTableViewCell.swift
//  ComputAS
//
//  Created by Daniel Turato on 03/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var ppImageLoadingView: UIActivityIndicatorView!
    
    var friend: Friend? {
    
        didSet {
            // Make sure each rows shows the correct data
            self.updateUI()
        
        }
    
    }
    // Updates the row selected to display the friend data
    func updateUI() {
        
        let userID: Int = (friend?.id)!
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let userImage = storageRef.child("\(userID).png")
        if let imageData = UserDefaults.standard.object(forKey: "\(friend?.username)-pic") {
            
            self.ppImageLoadingView.stopAnimating()
            self.friend?.profilePicture = UIImage(data: imageData as! Data)!
            self.profilePictureImageView?.image = UIImage(data: imageData as! Data)
            
        } else {
            
            // Loading the partiular user in this cells profile picture from cloud storage
            userImage.getData(maxSize: 11 * 1024 * 1024) { (data, error) in
            
                if let error = error {
                
                    print(error.localizedDescription)
                
                } else {
                    
                    UserDefaults.standard.set(data, forKey: "\(self.friend?.username)-pic")
                    
                    self.ppImageLoadingView.stopAnimating()
                    self.friend?.profilePicture = UIImage(data: data as! Data)!
                    self.profilePictureImageView?.image = UIImage(data: data as! Data)
                
                }
            
            
            }
        }

    
        // Sets the designs of profile picture
        profilePictureImageView?.layer.cornerRadius = (profilePictureImageView?.frame.size.width)! / 2
        profilePictureImageView?.layer.masksToBounds = true
        usernameLabel?.text = friend?.username
    
    
    }

    
}
