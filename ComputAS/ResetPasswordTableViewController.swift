//
//  ResetPasswordTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 16/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordTableViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    // if the reset button is pressed
    @IBAction func resetPasswordDidTap(_ sender: Any) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            // if missing info, error is shown
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "ResetRequiredInfoSegue", sender: nil)
            UIView.setAnimationsEnabled(true)
            return
        
        }
        
        // reset email is sent
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            
            if error != nil {
            
                self.performSegue(withIdentifier: "ResetErrorSegue", sender: nil)
                print(error!)
                
            
            } else {
            
                self.dismiss(animated: false, completion: nil)
            
            }
            
        }
        
    }
    
   
    
}
