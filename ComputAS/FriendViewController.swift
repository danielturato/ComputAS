//
//  FriendViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 30/01/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

class FriendViewController: UIViewController {
    
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    
    var requestMessage: String?
    var requestUser: UserL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        changeNotifications()
        friendsButton.addBottomBorderWithColour(colour: UIColor.white, width: 1.5)

    }
    
    
    func changeNotifications() {
        
        let friendRequests = FriendRequests.getFriendRequests()[0].friendRequests
        
        var runningTotal = 0
        
        for friendrq in friendRequests {
            
            runningTotal += 1
            
        }
        
        switch runningTotal {
        case 0:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (10)"))
        case 1:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (1)"))
        case 2:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (2)"))
        case 3:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (3)"))
        case 4:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (4)"))
        case 5:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (5)"))
        case 6:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (6)"))
        case 7:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (7)"))
        case 8:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (8)"))
        case 9:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (9)"))
        default:
            setImage(image: #imageLiteral(resourceName: "icons8-notification-50 (10)"))
        }
        
    }
    
    func setImage(image: UIImage) {
        
        notificationButton.setImage(image, for: .normal)
        
    }
    
    
    
}

