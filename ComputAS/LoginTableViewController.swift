//
//  LoginTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 16/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class LoginTableViewController: UITableViewController { // Use of object-orientated-programming

    // Outlets connecting to the login screen
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // URL for POST request to the server
    let URL_USER_LOGIN = "http://138.68.169.191/ComputAS/v1/login.php"
    
    // If the login button is tapped, this code runs
    @IBAction func loginDidTap(_ sender: Any) {
        
        //checks to see if there has been text inputted and if the info was correct.
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            
            //If it wasn't, error popup will show.
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "LoginRequiredInfoSegue", sender: nil)
            UIView.setAnimationsEnabled(true)
            return
        
        }
        
        let parameters: Parameters = [
        
            "email": email,
            "password": password
            
        ]
        
        // Request to the server, which will check the login details with the DB.
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON { response in
        
            // If theres a response, it will adjust its value
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                print(jsonData)
                // If thers not an error, the request will return the user information
                if(!(jsonData["error"] as! Bool)) {
                
                    let user = jsonData.value(forKey: "user") as! NSDictionary
                    
                    let newUser = User(userDict: user)
                    //Update the user information saved locally
                    newUser.updateUserDefaults()
                    
                    // Changes the login status
                    UserDefaults.standard.setIsLoggedIn(value: true)
                    // Updates the profile picture
                    self.updateProfilePicture(id: user["id"] as! Int)
                    self.performSegue(withIdentifier: "showWelcome", sender: nil)
                
                } else {
                    
                    self.performSegue(withIdentifier: "DisplayErrorSegue", sender: nil)
                
                }
                
            
            }
        
        }
        
        // After the request is finished, you will go back to the welcome screen.
        
    }
    
    // This function updates the current profile picture stored locally
    func updateProfilePicture(id: Int) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let userImage = storageRef.child("\(id).png")
        
        // Reguest too get the profile picture from the cloud storage
        userImage.getData(maxSize: 11 * 1024 * 1024) { (data, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                
            } else {
                
                // Saves the data of the image locally, save constant requests
                UserDefaults.standard.set(data as! NSData, forKey: "profileImage")
                
            }
            
            
        }
        
    }
    
}


