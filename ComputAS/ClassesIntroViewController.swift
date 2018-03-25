//
//  ClassesIntroViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 02/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

protocol childtop: class { // Protocol delegate to allow the user to tap button through different controllers
    
    func buttonClicked()
}

class ClassesIntroViewController: UIViewController {
    
    // Outlets for the view
    @IBOutlet weak var codeTextField: UITextField!
    
    // Request link
    let URL_JOIN_CLASS = "http://138.68.169.191/ComputAS/v1/joinclass.php"
    
    // The delegate for the protocol
    weak var delegate: childtop? = nil
    
    // If the user tap the join button
    @IBAction func joinButtonDidTap(_ sender: Any) {
        
        if !(codeTextField.text?.isEmpty)! { // If the tet field isn't empty
            
            let parameters: Parameters = [
            
                "code": codeTextField.text as! String,
                "id" : UserDefaults.standard.integer(forKey: "userID")
            
            ]
            
            // Request to the db to join a class
            Alamofire.request(URL_JOIN_CLASS, method: .post, parameters: parameters).responseJSON { (response) in
                
                if let result = response.result.value {
                    
                    let jsonData = result as! NSDictionary
                    
                    if (jsonData["error"] as? Bool)! { // If there is an error in the request
                        
                        
                        
                    } else {
                        
                        UserDefaults.standard.set(jsonData["message"] as! Int, forKey: "classID") // You join the class
                        self.performSegue(withIdentifier: "refreshSegue", sender: nil) // Refresh the controller
                        
                    }
                
                }
                
            }
            
            
        } else {
            
            // Show popup
            
        }
    
        
    }
    
    // If the user taps the create button
    @IBAction func createButtonDidTap(_ sender: Any) {
        
        delegate?.buttonClicked()
        tabBarController?.selectedIndex = 1 // You go to the create screen
        
    }
    
}
