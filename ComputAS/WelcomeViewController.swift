//
//  WelcomeViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 16/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController { // OOP, inherits from UIViewController
    
    
    // When the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // When the view is visible to the user
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Checks to see if theres a user already logged in and if there is, will show the home screen
        if isLoggedIn() {
            
            self.performSegue(withIdentifier: "ShowHome", sender: nil) // Peform ShowHome segue (go to home)
            
        }
        
    }
    
    
    // Function checked the user login status
    fileprivate func isLoggedIn() -> Bool {
        
        return UserDefaults.standard.isLoggedIn() // Checks UserDefaults to see check the user login status
        
    }

}
