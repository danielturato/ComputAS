//
//  ViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 12/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

extension UIView {
    
    // Adds an extension to the pre-existing UIView which will allows me to add a single border along any layer
    func addBottomBorderWithColour(colour: UIColor, width: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = colour.cgColor
        border.frame = CGRect(x:0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
        
    }
    
}

class HomeViewController: UIViewController { // Class inherits from UIViewController
    
    // These outlets connect to the Home View
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var contentHomeView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreHeaderLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var loadingImageCircleView: UIActivityIndicatorView!
    
    var ref: DatabaseReference!
    
    
    // URL's for POST requests
    let URL_TOTAL_PROGRESS = "http://138.68.169.191/ComputAS/v1/getprogress.php"
    let URL_GET_SCORE = "http://138.68.169.191/ComputAS/v1/getscore.php"
    let URL_GET_RANK = "http://138.68.169.191/ComputAS/v1/getuserrank.php"
    
    // When the view loads in the background, this function will execute
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        // Disable the navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .bottom, barMetrics: .default)
        //contentHomeView.addBottomBorderWithColour(colour: UIColor.lightGray, width: 1)
        profileButton.addBottomBorderWithColour(colour: UIColor.white, width: 1.5)
        
        progressBar() // Sets the progress
        setScore() // Sets the current score
        setRank() // Sets the current rank
        
        // Display Name
        nameLabel.text = UserDefaults.standard.string(forKey: "name")
    }
    
    // makes the battery symbol on top white instead of black
    override var preferredStatusBarStyle: UIStatusBarStyle {
    
        return .lightContent
        
    }
    
    // When the view is visible to the user
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setDetails() // The user details will be set , specifcly the profile picture
    }
    
    // This function sets all the details for the profile picture, certain animating occuring & design features
    func setDetails () {
        
        if let data = UserDefaults.standard.object(forKey: "profileImage") { // If thers a currently stored picture
            loadingImageCircleView.stopAnimating() // Stop the circular animation
            self.profileImageView.image = UIImage(data: data as! Data) // Set the profile picture
        } else { // Get the profile picture from the cloud storage
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let userImage = storageRef.child("\(UserDefaults.standard.integer(forKey: "userID")).png")
            userImage.getData(maxSize: 11 * 1024 * 1024) { (data, error) in

                if let error = error {

                    print(error.localizedDescription)

                } else {
                    UserDefaults.standard.set(data as! NSData, forKey: "profileImage") // Save the data in UserDefaults
                    self.loadingImageCircleView.stopAnimating()
                    self.profileImageView.image = UIImage(data: data as! Data) // Set as profile picture

                }


            }

        }
        // Provide circular style to picture
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.layer.masksToBounds = true
        
        // Set style features to other lables displaying user information
        let backgBlue = UIColor(red:0.20, green: 0.60, blue: 0.86, alpha: 1.0)
        scoreLabel.layer.borderColor = backgBlue.cgColor
        scoreLabel.layer.borderWidth = 2
        rankLabel.layer.borderColor = backgBlue.cgColor
        rankLabel.layer.borderWidth = 2
        
    }
    
    // This function displays the current score to the user
    func setScore() {
    
        let parameters: Parameters = [
        
            "userId" : UserDefaults.standard.integer(forKey: "userID")
        
        ]
        
        // Request to get the current score of the user
        Alamofire.request(URL_GET_SCORE, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                let score = Int(jsonData["score"] as! NSNumber)
                
                self.scoreLabel.text = String(describing: score) // Set the score in the label (display to the user)
                
            }
            
        }
    
    }
    // This function display the users current leaderboard ranking
    func setRank() {
        
        let parameters: Parameters = [
        
            "username" : UserDefaults.standard.string(forKey: "username") as! String
        
        ]
        // Request to get the current rank of the user
        Alamofire.request(URL_GET_RANK, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                
                let rank = jsonData["rank"] as! String
                let lastNumber = rank[rank.index(before: rank.endIndex)]
                
                switch lastNumber { // Depending on the rank, the text displayed will change
                    
                case "1" :
                    if rank.count == 2 && rank[rank.startIndex] == "1" {
                        self.rankLabel.text = "\(rank)th"
                    } else {
                        self.rankLabel.text = "\(rank)st"
                    }
                case "2":
                    if rank.count == 2 && rank[rank.startIndex] == "1" {
                        self.rankLabel.text = "\(rank)th"
                    } else {
                        self.rankLabel.text = "\(rank)nd"
                    }
                case "3":
                    if rank.count == 2 && rank[rank.startIndex] == "1" {
                        self.rankLabel.text = "\(rank)th"
                    } else {
                        self.rankLabel.text = "\(rank)rd"
                    }
                default:
                    self.rankLabel.text = "\(rank)th"
                    
                }
                
            }
            
        }
        
        
    }
    // This function displays the progress of the user in a particular design and gets the values from the DB
    func progressBar() {
        
        // The path in which the progress circle will follow
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: progressView.frame.size.width / 2, y: progressView.frame.size.height / 2), radius: (progressView.frame.size.width - 10) / 2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        // Simulate a path for the progress to follow
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0).cgColor
        trackLayer.lineWidth = 6
        
        progressView.layer.addSublayer(trackLayer) // Add the track path to the layer
        
        let circleLayer = CAShapeLayer() // The actual progress of the user
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor(red: 0.18, green:0.80, blue:0.44, alpha:1.0).cgColor
        circleLayer.lineWidth = 6
        circleLayer.lineCap = kCALineCapRound
        circleLayer.strokeEnd = 0.0
        
        progressView.layer.addSublayer(circleLayer) // Add the progress circle on top of the track layer
        
        let parameters: Parameters = [
        
            "userId": UserDefaults.standard.integer(forKey: "userID")
        
        ]
        
        var temp: Double = 0.0
        
        // Reguesting the total progress of the user
        Alamofire.request(URL_TOTAL_PROGRESS, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                // Adjusts the values accordingly
                let jsonData = result as! NSDictionary
                
                let progress = Double(jsonData["progress"] as! String)!
                
                temp = progress / 100
                
                let animation = CABasicAnimation(keyPath: "strokeEnd") // Animates the progress
                animation.toValue = temp
                animation.duration = 2
                animation.fillMode = kCAFillModeForwards
                animation.isRemovedOnCompletion = false
                circleLayer.add(animation, forKey: "bcAnimation")
                let circlperc = (temp / 0.8) * 100 // Sets the current total progress of the user
                
                self.progressLabel.text = "\(circlperc)% complete" // Edits the text inside the progress circle
                
                
            }
            
        }
        

    }


}
