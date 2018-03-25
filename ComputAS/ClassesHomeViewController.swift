//
//  ClassesHomeViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 03/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

class ClassesHomeViewController: UIViewController, childtop {

    // Outlets connecting to the view controller
    @IBOutlet weak var addTasksButton: UIButton!
    @IBOutlet weak var leaveClassButton: UIButton!
    @IBOutlet weak var classMenuButton: UIButton!
    
    var role: String?
    
    // This method is executed before a view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        classMenuButton.addBottomBorderWithColour(colour: UIColor.white, width: 1.5) // Style for menu option
        // Do any additional setup after loading the view.
        checkIfInClass() // Checks if the user is in a class

    }
    
    // This method is executed when the view appears to the user
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAvailableTasks() // Sets the tasks available to the teacher

    }
    
    // This function is used to give information to a segue which could run at any time
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ClassesTabBarViewController, segue.identifier == "tabBarSegue" {
            vc.delegate = self as? UITabBarControllerDelegate
        }
        
    }
    // Checks the tasks that are already assigned in this particular class and removes them from a constant list of taks
    func setAvailableTasks() {
        
        let URL_GET_USERS = "http://138.68.169.191/ComputAS/v1/getclasstasks.php"
        
        // All posible tasks that can be assigned
        var alltasks = ["[4.2.1.1] What are data structures?","[4.2.1.2] Arrays","[4.2.1.3] Fields, records and files", "[4.2.2.1] Queues", "[4.2.3.1] Stacks", "[4.2.4.1] Graphs", "[4.2.5.1] Trees", "[4.2.7.1] Dictionaries", "[4.2.8.1] Vectors"]
        
        let parameters: Parameters = [
            
            "classID": UserDefaults.standard.integer(forKey: "classID")
            
        ]
        
        // Request to the server to get the class tasks
        Alamofire.request(URL_GET_USERS, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let jsonData = result as! NSDictionary
                
                let temp_tasks = jsonData["tasks"]
                
                if !(temp_tasks is NSNull) {
                    
                    let tasks = (temp_tasks as! String).components(separatedBy: "||")
                    
                    for task in tasks { // Looping through the tasks
                        
                        if alltasks.contains(task) {
                            
                            alltasks.remove(at: alltasks.index(of: task)!) // Removes current tasks from list
                            
                        } else {
                            
                            continue
                            
                        }
                        
                    }
                    UserDefaults.standard.set(alltasks, forKey: "leftTasks") // Set UserDefaults for the tasks
                    
                } else {
                    
                    UserDefaults.standard.set(alltasks, forKey: "leftTasks")
                    
                }
                
            }
        }
        
    }
    // This function will check if the user is actually in a class, if they're then it will try determine their particular role in the class. If not, certain functionality will be disabled.
    func checkIfInClass() {
        
        let URL_GET_TEACHER_ID = "http://138.68.169.191/ComputAS/v1/getteacherid.php"
        
        guard let classID = UserDefaults.standard.object(forKey: "classID") else { // Check if there is a classID or not
            // If there isn't a classID at the moment
            addTasksButton.isEnabled = false
            leaveClassButton.isEnabled = false
           
            return
        }
        
        let parameters: Parameters = [
        
            "classID" : classID as! Int
        
        ]
        
        // Request to get the teacherID from the classID
        Alamofire.request(URL_GET_TEACHER_ID, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                let teacherID = result as! Int
                // Compare your classID to teacherID to determine the roles
                if teacherID != UserDefaults.standard.integer(forKey: "userID") {
                    
                    UserDefaults.standard.set("student", forKey: "role")
                    self.addTasksButton.isEnabled = false
                    
                } else {
                    
                    UserDefaults.standard.set("teacher", forKey: "role")
                    
                }
                
            }
            
        }
        
    }
    // If there is a role
    func buttonClicked() {
        
        addTasksButton.isEnabled = true
        addTasksButton.setImage(#imageLiteral(resourceName: "icons8-plus-51"), for: .normal)
        leaveClassButton.isEnabled = true
        addTasksButton.setImage(#imageLiteral(resourceName: "icons8-enter-50"), for: .normal)
        
    }
    
    // When the user clicks the add task button
    @IBAction func addTaskDidTap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addTaskSegue", sender: nil)
        
    }
    // When the user clicks the leave class button
    @IBAction func leaveClassDidTap(_ sender: Any) {
        
        self.performSegue(withIdentifier: "leaveSegue", sender: nil)
        
    }
    
    

    

}
