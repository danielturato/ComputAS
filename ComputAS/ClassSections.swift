//
//  ClassSections.swift
//  ComputAS
//
//  Created by Daniel Turato on 02/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ClassSection {

    var csections: [AnyObject]
    var name: String

    init(named: String, csection: [AnyObject]) {

        self.csections = csection
        self.name = named

    }

    class func getClassSections() -> [ClassSection] { // This method is a class method and returns a list of ClassSections

        return [allTasks(), allUsers()]

    }

    private class func allTasks() -> ClassSection { // Takes the tasks saved and creates a ClassSection for all tasks
        
        self.saveTasks()
        
        guard let tasksData = UserDefaults.standard.object(forKey: "classTasks") as? NSData else {
            
            return ClassSection(named: "Assigned Tasks", csection: [Task]())
            
        }
        guard let tasks = NSKeyedUnarchiver.unarchiveObject(with: tasksData as Data) as? [Task] else {
            
            return ClassSection(named: "Assigned Tasks", csection: [Task]())
        }
        
        return ClassSection(named: "Assigned Tasks", csection: tasks)

    }

    private class func allUsers() -> ClassSection { // Takes the users saved and creates a ClassSection for all users
        
        self.saveUsers()
        
        guard let usersData = UserDefaults.standard.object(forKey: "classUsers") as? NSData else {
            
            return ClassSection(named: "Users", csection: [ClassUser]())
            
        }
        guard let users = NSKeyedUnarchiver.unarchiveObject(with: usersData as Data) as? [ClassUser] else {
            
            return ClassSection(named: "Users", csection: [ClassUser]())
        }
        
        return ClassSection(named: "Users", csection: users)

    }

    class func saveTasks () { // Gets the tasks from db
        
        let URL_GET_USERS = "http://138.68.169.191/ComputAS/v1/getclasstasks.php"

        let parameters: Parameters = [
        
            "classID": UserDefaults.standard.integer(forKey: "classID")
        
        ]
        
        // Request to get the all the tasks from the db
        Alamofire.request(URL_GET_USERS, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                var tasksArray = [Task]()
                let jsonData = result as! NSDictionary
                
                let temp_tasks = jsonData["tasks"]
                
                if temp_tasks is NSNull {
                    
                    let tasksData = NSKeyedArchiver.archivedData(withRootObject: tasksArray)
                    UserDefaults.standard.set(tasksData, forKey: "classTasks")
                    
                } else {
                    
                    let tasks = (temp_tasks as! String).components(separatedBy: "||")
                    
                    for task in tasks {
                        
                        if task.isEmpty {
                            continue
                        }
                        
                        tasksArray.append(Task(name: task)) // Creates a Task object and appends it to the tasks array
                        
                    }
                    
                    let tasksData = NSKeyedArchiver.archivedData(withRootObject: tasksArray) // Saves the array in UserDefaults
                    UserDefaults.standard.set(tasksData, forKey: "classTasks")
                    
                }
            
            }
            
        }
    }

    class func saveUsers() { // Used to get the users in the class from the db

        let URL_GET_USERS = "http://138.68.169.191/ComputAS/v1/getclassusers.php"
        
        let parameters: Parameters = [
            
            "classID": UserDefaults.standard.integer(forKey: "classID")
            
        ]
        
        Alamofire.request(URL_GET_USERS, method: .post, parameters: parameters).responseJSON { (response) in
            
            if let result = response.result.value {
                
                var usersArray = [ClassUser]()
                
                let jsonData = result as! NSDictionary
                let users: NSArray = jsonData["users"] as! NSArray
                
                for user in users {
                    
                    let dictusers = user as! NSDictionary
                    let userID = dictusers["id"] as! Int
                    let username = dictusers["username"] as! String
                    let score = dictusers["score"] as! Int
                    
                    // Creates a ClassUser object and appends it to the users array
                    let tempUser = ClassUser(id: userID, username: username, score: score)
                    usersArray.append(tempUser)
                    
                    
                }
                // Saves the users array in UserDefaults to be decoded above
                let usersData = NSKeyedArchiver.archivedData(withRootObject: usersArray)
                UserDefaults.standard.set(usersData, forKey: "classUsers")
                
            }

        }



    }
    
}








