//
//  DataStructuresTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 20/01/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import SwiftyPlistManager
import Alamofire

class DataStructuresTableViewController: UITableViewController { // Class inheirts from UITableViewController
    
    // Sets all the outlets connecting to the table view
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var oneOneLabel: UILabel!
    @IBOutlet weak var oneTwoLabel: UILabel!
    @IBOutlet weak var oneThreeLabel: UILabel!
    @IBOutlet weak var twoOneLabel: UILabel!
    @IBOutlet weak var threeOneLabel: UILabel!
    @IBOutlet weak var fourOneLabel: UILabel!
    @IBOutlet weak var fiveOneLabel: UILabel!
    @IBOutlet weak var sevenOneLabel: UILabel!
    @IBOutlet weak var eightOneLabel: UILabel!
    
    
    // URL to get progress of this unit
    let URL_GET_UNIT_PROGRESS = "http://138.68.169.191/ComputAS/v1/getunitprogress.php"
    
    // Function runs before a view loads
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getInfo() // Get the progress information
        let progress: Float = checkProgress() // Set the progress value
        progressBar(progress: progress) // Set the progress
        
    }
    
    // Function to get the total progress for this unit.
    func getInfo() {
    
        let parameters: Parameters = [
        
            "userId" : UserDefaults.standard.integer(forKey: "userID"),
            "unit" : "UnitFourTwo"
            
        ]
        
        // Request to server to get the progress of this unit
        Alamofire.request(URL_GET_UNIT_PROGRESS, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                let currentProgress = Int(jsonData["value"] as! NSNumber)
                
                let green: UIColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
                
                if currentProgress >= 1 {
                
                    self.oneOneLabel.backgroundColor = green
                    
                    // Update the property-list file saved locally
                    SwiftyPlistManager.shared.save(true, forKey: "4.2.1.1", toPlistWithName: "UnitFourTwo", completion: { (err) in
                        
                        if err == nil {
                        
                            // No error
                        
                        }
                        
                    })
                
                }
                
            }
            
            
        }
        
    
    }
    
    // Check with a local plist file to see if any sub-units have been completed
    func checkProgress() -> Float {
        
        var runningTotal: Float = 0.0
    
        guard case let fourTwoOneOne as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.1.1", fromPlistWithName: "UnitFourTwo") else { return 0.0 }
        guard case let fourTwoOneTwo as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.1.2", fromPlistWithName: "UnitFourTwo") else { return 0.0 }
        guard case let fourTwoOneThree as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.1.3", fromPlistWithName: "UnitFourTwo") else { return 0.0 }
        guard case let fourTwoTwoOne as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.2.1", fromPlistWithName: "UnitFourTwo") else { return 0.0 }
        guard case let fourTwoThreeOne as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.3.1", fromPlistWithName: "UnitFourTwo") else { return 0.0 }
        guard case let fourTwoFourOne as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.4.1", fromPlistWithName: "UnitFourTwo") else { return 0.0 }
        guard case let fourTwoFiveOne as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.5.1", fromPlistWithName: "UnitFourTwo") else { return 0.0 }
        guard case let fourTwoSevenOne as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.7.1", fromPlistWithName: "UnitFourTwo") else { return 0.0 }
        guard case let fourTwoEightOne as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.8.1", fromPlistWithName: "UnitFourTwo") else { return 0.0 }

        let green: UIColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
        // If any of the subunits have been comopleted, the running total will increase 
        
        if fourTwoOneOne == true {
        
            oneOneLabel.backgroundColor = green
            runningTotal += 8.88
        
        }
        if fourTwoOneTwo == true {
            
            oneTwoLabel.backgroundColor = green
            runningTotal += 8.88
            
        }
        if fourTwoOneThree == true {
            
            oneThreeLabel.backgroundColor = green
            runningTotal += 8.88
            
        }
        if fourTwoTwoOne == true {
            
            twoOneLabel.backgroundColor = green
            runningTotal += 8.88
            
        }
        if fourTwoThreeOne == true {
            
            threeOneLabel.backgroundColor = green
            runningTotal += 8.88
            
        }
        if fourTwoFourOne == true {
            
            fourOneLabel.backgroundColor = green
            runningTotal += 8.88
            
        }
        if fourTwoFiveOne == true {
            
            fiveOneLabel.backgroundColor = green
            runningTotal += 8.88
            
        }
        if fourTwoSevenOne == true {
            
            sevenOneLabel.backgroundColor = green
            runningTotal += 8.88
            
        }
        if fourTwoEightOne == true {
            
            eightOneLabel.backgroundColor = green
            runningTotal += 9.6
            
        }
        
        return runningTotal
        
    }
    
    // Creates a progress circle based upon the progress completed in this unit
    func progressBar(progress: Float) {
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: progressView.frame.size.width / 2, y: progressView.frame.size.height / 2), radius: (progressView.frame.size.width - 10) / 2, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.lineCap = kCALineCapRound
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor(red: 0.17, green: 0.24, blue: 0.31, alpha: 1.0).cgColor
        trackLayer.lineWidth = 6
        
        progressView.layer.addSublayer(trackLayer)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor(red: 0.18, green:0.80, blue:0.44, alpha:1.0).cgColor
        circleLayer.lineWidth = 6
        circleLayer.lineCap = kCALineCapRound
        circleLayer.strokeEnd = 0.0
        
        progressView.layer.addSublayer(circleLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = progress / 100
        animation.duration = 2
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        circleLayer.add(animation, forKey: "bcAnimation")
        
        let circlperc = (progress / 80) * 100
        progressLabel.text = "\(circlperc)% complete"
    
    }

}
