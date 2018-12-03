//
//  RegisterTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 13/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


// An extension to the built in functionality of UIImage, which allows me to change the quality of images at an easier level
extension UIImage {
    
    enum JPEGQuality: CGFloat { // Set an enumeration
        
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
        
    }
    
    func jpeg(_ quality: JPEGQuality) -> Data? { // Function which allows me to choose the quality of an image
        
        return UIImageJPEGRepresentation(self, quality.rawValue)
        
    }
    
}
// OOP, inherits UITableViewController and follows the protocls after the inheritance
class RegisterTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // Below are all the outlets that are connected to the register controller
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    @IBOutlet weak var createNewAccountButton: UIButton!
    
    
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    
    var profilePicture: UIImage!
    
    // Connects to the cloud storage
    let storage = Storage.storage()
    
    // URL's for POST requests to the server
    let URL_USER_REGISTER = "http://138.68.169.191/ComputAS/v1/register.php"
    let URL_USER_LOGIN = "http://138.68.169.191/ComputAS/v1/login.php"
    
    // When the view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingActivityView.stopAnimating() // The activity view will stop animating
    }
    
    // This allows the user is either take a picture or select a picture to use as their profile picture
    @IBAction func changeProfilePictureDidTap(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {  // If the user chooses a camera
        
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: false, completion: nil) // Show camera
        
        } else { // If not, let the user pick from current pictures
        
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: false, completion: nil)

        
        }
        
    }
    // This sets the picture to be their profile picture and creates the circular effect
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage { // Let the user choose image
            
            // Once the image is picked, apply styles and set a profile picture
            profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
            profileImageView.layer.masksToBounds = true
            profileImageView.image = image
            profilePicture = profileImageView.image
            
            
            
        }
        
        self.dismiss(animated: false, completion: nil) // Once finished, go back to register screen
        
    }
    // When you tap the create account button, this runs
    @IBAction func createNewAccountDidTap(_ sender: Any) {
        
        createNewAccountButton.isEnabled = false
        createNewAccountButton.backgroundColor = UIColor(red: 0.58, green: 0.65, blue: 0.65, alpha: 1.0)
        loadingActivityView.startAnimating()
        //1. signing up new acccount
        // Checks to see that everything is correctly inputted or inputted at all
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField
            .text, !password.isEmpty, let fullName = fullNameTextField.text, !fullName.isEmpty, let age = ageTextField.text, !age.isEmpty, let verifyPassword = verifyPasswordTextField.text, !verifyPassword.isEmpty, profilePicture != nil else {
                // If it isn't, the error code is shown
                UIView.setAnimationsEnabled(false)
                self.performSegue(withIdentifier: "RegisterRequiredInfoSegue", sender: nil)
                UIView.setAnimationsEnabled(true)
                return
        
        }
        
        if verifyPassword == password {
            
            let score = 0
        
        
            let parameters: Parameters = [
            
                "username": username,
                "password": password,
                "email": email,
                "name" : fullName,
                "age" : age,
                "score": score
            
            ]
            
            let loginParameters: Parameters = [
            
                "email": email,
                "password": password
            
            ]
            
            // Sends a POST request to the server with the required info
            Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON { response in
            
                if let result = response.result.value {
    
                    let jsonData = result as! NSDictionary
                    
                    if (jsonData["error"] as! Bool) {
                        
                        self.performSegue(withIdentifier: "RegisterErrorSegue", sender: nil)
                        
                    } else {
                    
                        self.setEverything(loginParameters: loginParameters)
                    
                    }
                    
                }
                
            
            }
        
        
        } else {
            
            // Show error popup
            
        }
        

    }
    // This function is used to set the UserDefaults
    func setEverything(loginParameters: Parameters) {
        
        // Login in the user
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: loginParameters).responseJSON { response in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                if(!(jsonData.value(forKey: "error") as! Bool)) {
                    
                    let user = jsonData.value(forKey: "user") as! NSDictionary // Create a new user
                    
                    // Store the profile picture the user picked
                    self.storeProfilePicture(profilePicture: self.profilePicture, userID: user["id"] as! Int)
                    
                    
                } else {
                    
                    // ERROR
                    
                }
                
                
            }
            
            
        }
        
    }
    // This function stores the selected profile picture locally & in the cloud storage
    func storeProfilePicture(profilePicture: UIImage, userID: Int) {
        
        let storageRef = self.storage.reference().child("\(userID).png") // Create a new cloud storage path
        let imageData: Data = UIImagePNGRepresentation(profilePicture)! as Data // Turn the picture into binary
        
        UserDefaults.standard.set(imageData, forKey: "profileImage") // Store the binary data
        
        let uploadData = profilePicture.jpeg(.lowest) // Get the smallest file-size
        
        storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in // Store the image in storage
                
        if error != nil { // If theres an error
            print(error?.localizedDescription)
            return
                    
        }
        self.loadingActivityView.stopAnimating()
        self.performSegue(withIdentifier: "showWelcome", sender: nil) // Go back to welcome screen once uploaded
                
        })
        
    }

}
