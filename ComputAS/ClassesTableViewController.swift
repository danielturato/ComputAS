//
//  ClassesTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 03/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

// An extension to String
extension String {
    
    func removingWhitespaces() -> String { // Removes the whitespaces in a string
        
        return components(separatedBy: .whitespaces).joined()
        
    }
    
}

class ClassesTableViewController: UITableViewController {
    
    var classSections: [ClassSection] = ClassSection.getClassSections() // Gets all tasks, users in a class
    let sectionImages: [UIImage] = [#imageLiteral(resourceName: "icons8-task-35"), #imageLiteral(resourceName: "icons8-school-director-35")] // Array of images in a sectio

    // This method is run before a view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl() // Allows the table to be refreshed
        // Everytime theres a refresh, the refreshSections method is executed
        refreshControl.addTarget(self, action: #selector(refreshSections), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
    }
    
    // This method is executed everytime the user pulls to refresh
    @objc func refreshSections() {
    
        classSections = ClassSection.getClassSections() // Re-collects the class-sections
        tableView.reloadData()
        refreshControl?.endRefreshing()
    
    }
    // The number of sections in the table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return classSections.count
    }
    
    // The number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classSections[section].csections.count
    }
    
    // The view of each row at a specific index
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // The cells that could be used in the table view
        let userCell = tableView.dequeueReusableCell(withIdentifier: "ClassUserCell", for: indexPath) as! ClassUserTableViewCell
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "ClassTaskCell", for: indexPath) as! ClassTaskTableViewCell
        
        // Get the specific object in the classSections array
        let classSection = classSections[indexPath.section]
        let section = classSection.csections
        let item = section[indexPath.row]
        
        switch item { // Depending on the object type, it will return a differnt object
        case is Task:
            taskCell.task = item as! Task
            return taskCell
        case is ClassUser:
            userCell.user = item as! ClassUser
            return userCell
        default:
            return userCell
        }
        
    }
    
    // If the user selects the cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = classSections[indexPath.section].csections[indexPath.row] // Grab the object at that index
        
        switch item { // Checks which object type the item is at
        
        case is Task:
            var taskName = (item as! Task).name
            taskName = taskName.trimmingCharacters(in: [" ", "[", "]", ".", "1", "2", "0", "3", "4", "5", "6", "7", "8", "9", "?"])
            taskName = taskName.removingWhitespaces()
            self.performSegue(withIdentifier: "\(taskName)Segue", sender: nil)
        default:
            print("nothing")
        }
        
    }
    
    // The height for each section header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    // The editable actions on each table view cell
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        // This action allows the teacher to remove task/student
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in

            if UserDefaults.standard.string(forKey: "role") == "teacher" {
                
                switch self.classSections[indexPath.section].csections[indexPath.row] {
                case is ClassUser:
                    
                    let URL_REMOVE_STUDENT = "http://138.68.169.191/ComputAS/v1/removestudentfromclass.php"
                    
                    let id = (self.classSections[indexPath.section].csections[indexPath.row] as! ClassUser).id
                    
                    if id != UserDefaults.standard.integer(forKey: "userID") {
                    
                        let parameters: Parameters = [
                        
                            "id" : id
                        
                        ]
                        
                        // Request to remove a student
                        Alamofire.request(URL_REMOVE_STUDENT, method: .post, parameters: parameters).responseJSON { (response) in
                            // Remove the user from object array
                            self.classSections[indexPath.section].csections.remove(at: indexPath.row)
                            // Delete the rows from the table
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        
                        
                        }
                    } else {
                        
                        // Show popup
                        
                    }
                case is Task: // If the type is Task, will remove the task
                    
                    let URL_REMOVE_TASK = "http://138.68.169.191/ComputAS/v1/removetaskfromclass.php"
                    
                    
                    let parameters: Parameters = [
                        
                        "task": (self.classSections[indexPath.section].csections[indexPath.row] as! Task).name + "||",
                        "classID": UserDefaults.standard.integer(forKey: "classID")
                        
                    ]
                    // Request to remove the task from the db
                    Alamofire.request(URL_REMOVE_TASK, method: .post, parameters: parameters).responseJSON { (response) in
                        
                        self.classSections[indexPath.section].csections.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        
                        
                    }
                default:
                    print("default")
                    
                }
                

            } else {
                print("NOT ALLOED")
                // show popup

            }

        }

        remove.backgroundColor = UIColor(red: 0.91, green: 0.30, blue: 0.23, alpha: 1.0)


        // Sets the action on the cell
        return[remove]

    }
    // Sets the view for the header on each section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Sets the size/background
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.77, blue: 0.06, alpha: 1.0 )
        
        // Sets the image
        let image = UIImageView(image: sectionImages[section])
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(image)
        
        // Sets the title
        let label = UILabel()
        label.text = classSections[section].name
        label.frame = CGRect(x: 45, y: 5, width: 150, height: 35)
        label.textColor = UIColor.white
        view.addSubview(label)
        
        // Returns the view containing everything included above 
        return view
    }

    

}
