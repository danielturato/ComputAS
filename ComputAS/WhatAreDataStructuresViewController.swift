//
//  WhatAreDataStructuresViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 21/01/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyPlistManager

class WhatAreDataStructuresViewController: UIViewController {

    // Outlet connecting to the view
    @IBOutlet weak var completeButton: UIButton!
    
    // All the server request URLS
    let URL_GET_UNIT_PROGRESS = "http://138.68.169.191/ComputAS/v1/getunitprogress.php"
    let URL_UPDATE_UNIT_PROGRESS = "http://138.68.169.191/ComputAS/v1/updateprogress.php"
    let URL_GET_SCORE = "http://138.68.169.191/ComputAS/v1/getscore.php"
    let URL_UPDATE_SCORE = "http://138.68.169.191/ComputAS/v1/updatescore.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isCompleted() // Check to see if this sub-unit has been completed

        // Do any additional setup after loading the view.
    }
    
    // Checks to see if this unit has been completed before, if so will disable the mark as complete button
    func isCompleted() {
    
        guard case let hasCompleted as Bool = SwiftyPlistManager.shared.fetchValue(for: "4.2.1.1", fromPlistWithName: "UnitFourTwo") else { return }
        
        if hasCompleted { // Will disable the button if it has been completed
        
            completeButton.isEnabled = false
            completeButton.backgroundColor = UIColor(red: 0.58, green: 0.65, blue: 0.65, alpha: 1.0)
        
        }
        
    }
    
    // If you tap the complete button
    @IBAction func completeButtonDidTap(_ sender: Any) {
        
        // Update the plist file
        SwiftyPlistManager.shared.save(true, forKey: "4.2.1.1", toPlistWithName: "UnitFourTwo", completion: { (err) in
                
            if err == nil {
                
                    //Do nothing
            }
                
        })
        
        let parameters: Parameters = [
        
            "userId" : UserDefaults.standard.integer(forKey: "userID"),
            "unit" : "UnitFourTwo"
        
        ]
        // Get your current progress in this unit
        Alamofire.request(URL_GET_UNIT_PROGRESS, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                let currentProgress = Int(jsonData["value"] as! NSNumber)
                
                self.updateDb(value: currentProgress) // Update that progress in the db
                
            }
            
            
        }
        
        let parametersTwo: Parameters = [
        
            "userId" : UserDefaults.standard.integer(forKey: "userID")
        
        ]
        
        // Get your current score from the database
        Alamofire.request(URL_GET_SCORE, method: .post, parameters: parametersTwo).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                let currentScore = Int(jsonData["score"] as! NSNumber)
                
                self.updateScore(value: currentScore) // Update that score in the db
                
                // Show a default score gained from completing a unit
                self.performSegue(withIdentifier: "showScore", sender: nil)

            }
            
        }
        
        
        
    }
    // Updates your user score
    func updateScore(value: Int) {
    
        let newScore = value + 25
        
        let parameters: Parameters = [
        
            "userId" : UserDefaults.standard.integer(forKey: "userID"),
            "newScore": newScore
        
        ]
        
        Alamofire.request(URL_UPDATE_SCORE, method: .post, parameters: parameters).responseJSON { (response) in
            
            
            
        }
    
    }
    
    // Will update the learningcontent db with your recent progress
    func updateDb(value: Int) {
    
        let newProgress = value + 1
        
        let parameters: Parameters = [
        
            "userId" : UserDefaults.standard.integer(forKey: "userID"),
            "unit" : "UnitFourTwo",
            "newValue" : newProgress
        
        ]
        
        Alamofire.request(URL_UPDATE_UNIT_PROGRESS, method: .post, parameters: parameters).responseJSON { (response) in
            
            
            
            
        }
        
    
    }
    

}


