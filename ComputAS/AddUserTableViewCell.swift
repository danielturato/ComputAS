//
//  AddUserTableViewCell.swift
//  ComputAS
//
//  Created by Daniel Turato on 18/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

// A protocol which means that if this is assigned to a class, the class has to conform to whats in the protocol
protocol AddUserTableViewCellDelegate {
    
    func addUserTableViewCellDidTapAddFriend(user: UserL)
    
}

class AddUserTableViewCell: UITableViewCell {
    
    var delegate: AddUserTableViewCellDelegate?

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var addFriendButton: UIButton!
    
    var user: UserL? {
        
        didSet {
            
            self.updateUI()
            
        }
        
    }
    
    // If the user varibale is set, this function is run to update the UI
    func updateUI() {
        
        if user?.username == UserDefaults.standard.string(forKey: "username") {
            
            addFriendButton.isEnabled = false
            
        } else {
            
            usernameLabel?.text = user?.username
            
        }
        
        let userID: Int = (user?.id)!
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let userImage = storageRef.child("\(userID).png")
        
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

    // This function is executed once they click the add button
    @IBAction func addFriendDidTap(_ sender: Any) {
       
        delegate?.addUserTableViewCellDidTapAddFriend( user: user!)
        
    }
    
    
    
}
