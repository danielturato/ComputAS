//
//  SettingsTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 19/01/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

// An extension to UITextField which makes it easy to change the placeholder text colour
extension UITextField {

    // In storyboards, I can now change the placeholder color with ease
    @IBInspectable var placeHolderColor: UIColor? {
    
        get {
        
            return self.placeHolderColor
            
        }
        set {
        
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        
        }
    
    }

}

// Class inherits from UITableView Controller and follows the rules of the delegates
class SettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Outlets connecting the different elements on the page
    @IBOutlet weak var changeUsernameButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var selectPictureButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    
    // Request URL's for later functionality
    let URL_CHANGE_USERNAME = "http://138.68.169.191/ComputAS/v1/changeusername.php"
    let URL_CHANGE_NAME = "http://138.68.169.191/ComputAS/v1/changename.php"
    let URL_CHANGE_EMAIL = "http://138.68.169.191/ComputAS/v1/changeemail.php"
    let URL_DELETE_USER = "http://138.68.169.191/ComputAS/v1/deleteuser.php"

    // Just as the view loads, this function will execute
    override func viewDidLoad() {
        super.viewDidLoad() // Super the viewDidLoad
        
        // When the view first loads, these design functions will be called
        settingsLabel.addBottomBorderWithColour(colour: UIColor(red:0.20, green: 0.29, blue: 0.37, alpha: 1.0), width: 2)
        buttonBorders() // Add borders on buttons
        circlePP() // Add profile picture stylying
        

    }
    
    // This function adds borders on only the bottom of certain items.
    func buttonBorders() {
        
        let midblue = UIColor(red:0.20, green: 0.29, blue: 0.37, alpha: 1.0)
    
        changeUsernameButton.layer.borderColor = midblue.cgColor
        changeUsernameButton.layer.borderWidth = 1.5
        changeEmailButton.layer.borderColor = midblue.cgColor
        changeEmailButton.layer.borderWidth = 1.5
        selectPictureButton.layer.borderColor = midblue.cgColor
        selectPictureButton.layer.borderWidth = 1.5
        changeNameButton.layer.borderColor = midblue.cgColor
        changeNameButton.layer.borderWidth = 1.5
        
    }
    
    // This function creates a circular design around the profile picture
    func circlePP() {
        
        let data = UserDefaults.standard.object(forKey: "profileImage") as! NSData
        self.profilePictureView.image = UIImage(data: data as Data)
        self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2
        self.profilePictureView.layer.masksToBounds = true
    
    }
    
    
    // If the user taps change username, this function will run
    @IBAction func changeUsernameDidTap(_ sender: Any) {
        
        if (!(usernameTextField.text?.isEmpty)!) { // If the user has entered a new username
            
            let parameters: Parameters = [
            
                "newUsername" : usernameTextField.text as! String,
                "id" : UserDefaults.standard.integer(forKey: "userID")
            
            ]
            
            // Request to change the username using the above parameters
            Alamofire.request(URL_CHANGE_USERNAME, method: .post, parameters: parameters).responseJSON { (response) in
                
                if let result = response.result.value {
                    
                    let jsonData = result as! NSDictionary
                    let errorCode = Bool(jsonData["error"] as! String)
                    
                    if (errorCode)! {
                        
                        // show username already taken popup
                        
                    } else {
                        
                        UserDefaults.standard.set(parameters["newUsername"] as! String, forKey: "username") // Userdefaults will change with new username
                        self.usernameTextField.text = ""
                        
                        // show username has changed
                        
                    }
                }
                
            }
            
        } else {
            
            // Show too short of a username screen
            usernameTextField.text = ""
            
        }
        
    }
    
    
    // This function will run once the user taps change email
    @IBAction func changeEmailDidTap(_ sender: Any) {
        
        if (!(emailTextField.text?.isEmpty)!) {
            
            let parameters: Parameters = [
            
                "newEmail" : emailTextField.text as! String,
                "id" : UserDefaults.standard.integer(forKey: "userID")
            
            ]
            
            // The request to change the email
            Alamofire.request(URL_CHANGE_EMAIL, method: .post, parameters: parameters).responseJSON { (response) in
                
                if let result = response.result.value {
                    
                    let jsonData = result as! NSDictionary
                    let errorCode = Bool(jsonData["error"] as! String)
                    
                    if (errorCode)! {
                        
                        // show email already taken
                        
                    } else {
                        
                        UserDefaults.standard.set(parameters["newEmail"], forKey: "email") // New UserDefaults will change
                        self.emailTextField.text = ""
                        
                        // show email changed
                        
                    }
                    
                } else {
                    
                    self.emailTextField.text = ""
                    // show error popup
                    
                }
                
            }
            
        }
        
        
        
    }
    
    // If the user taps, change picture they will be brought too a selection screen
    @IBAction func selectPictureDidTap(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: false, completion: nil)
            
        } else {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: false, completion: nil)
            
            
        }
        
    }
    
    // This function allows the ability to take a picture with the camera or scroll through a users photo album
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            profilePictureView.layer.cornerRadius = profilePictureView.bounds.width / 2.0
            profilePictureView.layer.masksToBounds = true
            profilePictureView.image = image
            let profilePicture = profilePictureView.image
            
            let imageData: NSData = UIImagePNGRepresentation(profilePicture!)! as NSData
            UserDefaults.standard.set(imageData, forKey: "profileImage")
            
            // Change profile image in firebase storage
            
            
            
        }
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    // This function is executed when the user taps change name
    @IBAction func changeNameDidTap(_ sender: Any) {
        
        if (!(nameTextField.text?.isEmpty)!) {
            
            let parameters: Parameters = [
            
                "newName" : nameTextField.text as! String,
                "id" : UserDefaults.standard.integer(forKey: "id")
            
            ]
            
            Alamofire.request(URL_CHANGE_NAME, method: .post, parameters: parameters).responseJSON { (response) in
                
                if let result = response.result.value {
                    
                    let jsonData = result as! NSDictionary
                    
                    UserDefaults.standard.set(parameters["newName"], forKey: "name")
                    self.nameTextField.text = ""
                    // peform segue
                    
                }
                
                
            }
            
        } else {
            
            self.nameTextField.text = ""
            // show popup error
            
            
        }
        
    }
    
    // When clicked, the login status will change to false and you will go back to the welcome screen
    @IBAction func signOutDidTap(_ sender: Any) {
        
        UserDefaults.standard.setIsLoggedIn(value: false)
        self.performSegue(withIdentifier: "goOutSegue", sender: nil)
        
    }
    
    
    @IBAction func deleteAccountDidTap(_ sender: Any) {
        
        //UserDefaults.standard.setIsLoggedIn(value: false)
        
    }
    
    

}
