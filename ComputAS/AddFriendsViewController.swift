//
//  AddFriendsViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 14/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController {
    
    var requestMessage: String?
    var requestUser: UserL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if requestMessage == "error" {
            
            requestMessage = ""
            self.performSegue(withIdentifier: "errorFriendRequest", sender: nil)
            
        } else if requestMessage == "sent" {
            
            requestMessage = ""
            self.performSegue(withIdentifier: "friendRequestSent", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "friendRequestSent" {
            
            let friendHomeVC = segue.destination as! FriendRequestPPViewController
            
            friendHomeVC.user = requestUser
            
        }
        
    }

}
