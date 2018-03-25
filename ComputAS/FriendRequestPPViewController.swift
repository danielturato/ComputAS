//
//  FriendRequestPPViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 18/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

class FriendRequestPPViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var user: UserL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageLabel.text = "You've sent a friend request too \(user?.username as! String)"
    }


}
