//
//  ClassesDisbandLeaveViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 08/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

class ClassesDisbandLeaveViewController: UIViewController {
    
    // Outlets connecting to the view
    @IBOutlet weak var disbandLabel: UILabel!
    
    // This method is executed before a view loads
    override func viewDidLoad() {
        super.viewDidLoad()

        // Changes disband text depending on use role
        if UserDefaults.standard.string(forKey: "role") as! String == "student" {
            
           disbandLabel.text = "Are you sure you want to leave?"
            
        } else {
            
            disbandLabel.text = "Are you sure you want to disband?"
            
        }
 
    }

    // If the user taps yes
    @IBAction func yesDidTap(_ sender: Any) {
        
        if UserDefaults.standard.string(forKey: "role") as! String == "teacher" {
            
            let URL_DISBAND_CLASS = "http://138.68.169.191/ComputAS/v1/disbandclass.php"
            
            let parameters: Parameters = [
                
                "classID" : UserDefaults.standard.integer(forKey: "classID")
                
            ]
            // Request to disband the class
            Alamofire.request(URL_DISBAND_CLASS, method: .post, parameters: parameters).response { (response) in
                
                UserDefaults.standard.removeObject(forKey: "classID") // Remove saved info
                self.performSegue(withIdentifier: "backToClassesSegue", sender: nil) // Go back to intro screen
                
            }
            
            
        } else {
            
            let URL_LEAVE_CLASS = "http://138.68.169.191/ComputAS/v1/leaveclass.php"
            
            let parameters: Parameters = [
            
                "id" : UserDefaults.standard.integer(forKey: "userID")
            
            ]
            // Request to leave the class in db
            Alamofire.request(URL_LEAVE_CLASS, method: .post, parameters: parameters).response { (response) in
                
                // Removes the class from stored data
                UserDefaults.standard.removeObject(forKey: "classID")
                self.performSegue(withIdentifier: "backToClassesSegue", sender: nil)
                
                
            }
            
            
        }
        
    }
    
    
    
}
