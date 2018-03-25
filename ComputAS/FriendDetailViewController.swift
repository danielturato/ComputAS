//
//  FriendDetailViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 04/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

class FriendDetailViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    // Data will be set after entering the view
    var friend: Friend?
    
    let URL_GET_SCORE = "http://138.68.169.191/ComputAS/v1/getscore.php"
    let URL_GET_RANK = "http://138.68.169.191/ComputAS/v1/getuserrank.php"
    
    // Upon loading the view, will loads all the data into the cells
    override func viewDidLoad() {
        
        let userID: Int = (friend?.id)!
        
        profilePictureImageView.image = friend?.profilePicture
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width / 2
        profilePictureImageView.layer.masksToBounds = true
        fullNameLabel.text = friend?.fullName
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let navy = UIColor(red:0.20, green:0.29, blue:0.37, alpha:1.0)
        scoreLabel.layer.borderColor = navy.cgColor
        scoreLabel.layer.borderWidth = 2
        rankLabel.layer.borderColor = navy.cgColor
        rankLabel.layer.borderWidth = 2
        
        setScore()
        setRank()
    }
    
    func setScore() {
        
        let parameters: Parameters = [
            
            "userId" : friend?.id as! Int
            
        ]
        
        Alamofire.request(URL_GET_SCORE, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                let score = Int(jsonData["score"] as! NSNumber)
                
                self.scoreLabel.text = String(describing: score)
                
            }
            
        }
        
    }
    
    func setRank() {
        
        let parameters: Parameters = [
            
            "username" : friend?.username as! String
            
        ]
        
        Alamofire.request(URL_GET_RANK, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                
                let rank = jsonData["rank"] as! String
                let lastNumber = rank[rank.index(before: rank.endIndex)]
                
                switch lastNumber {
                    
                case "1" :
                    self.rankLabel.text = "\(rank)st"
                case "2":
                    self.rankLabel.text = "\(rank)nd"
                case "3":
                    self.rankLabel.text = "\(rank)rd"
                default:
                    self.rankLabel.text = "\(rank)th"
                    
                }
                
            }
            
        }
        
        
    }
    
}




