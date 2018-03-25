//
//  ClassesTabBarViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 01/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

class ClassesTabBarViewController: UITabBarController { // Controller for the multiple tabs used in the class
    
    // Request link to check if the use is in a class
    let URL_CHECK_FOR_CLASSES = "http://138.68.169.191/ComputAS/v1/checkforclass.php"

    // This function will execute before a view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.layer.zPosition = -1 // Hides the bottom bar usually found on a tab bar controller
        checkIfInClass() // Checks if the user is in a class
        
    }
    // This function will check if they're in a class , if so then it will change the display of scren depending on if you're in a class or not.
    func checkIfInClass() {
        
        let parameters: Parameters = [
        
            "id" : UserDefaults.standard.integer(forKey: "userID")
        
        ]
        // Requests the db to check if the user is in a class
        Alamofire.request(URL_CHECK_FOR_CLASSES, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                let errorCode = Bool(jsonData["error"] as! String)
                
                if (errorCode)! { // If the user isn't in a class
                    
                    self.selectedIndex = 0 // Go to intro scree
                    
                } else { // If the user is in a class
                    
                    self.selectedIndex = 2 // Go to main classes screen
                    
                    
                }
            }
            
        }
        
    }

}
