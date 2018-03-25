//
//  ClassTaskPickerViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 03/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Alamofire

// Class must follow the rules of the protocols
class ClassTaskPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Outlets connecting to the view
    @IBOutlet weak var pickerView: UIPickerView!
    
    // The left tasks assigned earlier
    var leftTasks = UserDefaults.standard.array(forKey: "leftTasks") as! [String]

    var selectedTask: String = ""
    
    // This method is executed before a view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up the picker view
        pickerView.delegate = self
        pickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    // Number of components per pick
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The title for each pick
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return leftTasks[row]
    }
    // The number of rows in each pick
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return leftTasks.count
    }
    // What happens when you select a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedTask = leftTasks[row]
    }

    // When the user taps add
    @IBAction func addDidTap(_ sender: Any) {
        
        let URL_ADD_TASK = "http://138.68.169.191/ComputAS/v1/addnewtask.php"
        
        if !selectedTask.isEmpty {
            print(selectedTask)
            let parameters: Parameters = [
        
                "classID": UserDefaults.standard.object(forKey: "classID"),
                "newTask": "\(selectedTask)||"
        
            ]
            // Request to the db to add a new task 
            Alamofire.request(URL_ADD_TASK, method: .post, parameters: parameters).responseJSON { (response) in
                
                self.performSegue(withIdentifier: "backToClassSegue", sender: nil)
                
            }
            
            
            
        } else {
            
            // show popup
            
        }
        
    }
    
}
