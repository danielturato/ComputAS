//
//  ClassesNewTeacherViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 02/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

class ClassesNewTeacherViewController: UIViewController {
    
    // Outlets connected to the view
    @IBOutlet weak var codeLabel: UILabel!
    
    let URL_NEW_CLASS = "http://138.68.169.191/ComputAS/v1/newTeacherClass.php"
    
    // This method will execute before the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        generateCode() // Generates a new code
        // Do any additional setup after loading the view.
    }
    
    // This method is used to generate a new code
    func generateCode() {
    
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var ch = Array(chars)
        var s: String = ""
        for n in (1...6) {
            s.append(ch[Int(arc4random()) % ch.count]) // Up to 6 characters which creates a random character alphanumeric
        }
        
        codeLabel.text = s
        
    }

    // If the users taps the continue button
    @IBAction func continueDidTap(_ sender: Any) {
        
        let parameters: Parameters = [
        
            "id": UserDefaults.standard.integer(forKey: "userID"),
            "code": codeLabel.text as! String
        
        ]
        // This request to the db creates a new class
        Alamofire.request(URL_NEW_CLASS, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let classID = result as! Int
                UserDefaults.standard.set(classID, forKey: "classID") // Sets the UserDefaults for the classID
                
                self.tabBarController?.selectedIndex = 2 // Segue to the home classes screen
                
            }
            
        }
        
        
        
    }
    

}
