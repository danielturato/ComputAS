//
//  UnitPickerViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 12/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

// Class follows protocols and inherits from UIViewController
class UnitPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Sets outlets connected too view
    @IBOutlet weak var unitPickerView: UIPickerView!
    let units = ["[4.2] Fundamentals of data structures",
                 "[4.3] Fundamentals of algorithms",
                 "[4.5] Fundamentals of data representation",
                 "[4.6] Fundamentals of computer systems",
                 "[4.7] Computer organisation & architecture",
                 "[4.9] Communication and networking",
                 "[4.10] Fundamentals of databases",
                 "[4.11] Big Data"]
    
    var selectedTask: String = ""
    
    //Before a view loads, this function is executed
    override func viewDidLoad() {
        super.viewDidLoad()

        unitPickerView.delegate = self
        unitPickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    // The number of components per pick in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The title of each pick in the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    // The amount of choices you can pick the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch units[row] { // Will set the selected row depends on what unit the user picks
        case "[4.2] Fundamentals of data structures":
            selectedTask = "UnitFourTwo"
        case "[4.3] Fundamentals of algorithms":
            selectedTask = "UnitFourThree"
        case "[4.5] Fundamentals of data representation":
            selectedTask = "UnitFourFive"
        case "[4.6] Fundamentals of computer systems":
            selectedTask = "UnitFourSix"
        case "[4.7] Computer organisation & architecture":
            selectedTask = "UnitFourSeven"
        case "[4.9] Communication and networking":
            selectedTask = "UnitFourNine"
        case "[4.10] Fundamentals of databases":
            selectedTask = "UnitFourTen"
        case "[4.11] Big Data":
            selectedTask = "UnitFourEleven"
        default:
            selectedTask = "UnitDefault"
        }
        
    }

    // If the user taks go
    @IBAction func goDidTap(_ sender: Any) {
        
        if !(selectedTask.isEmpty) { // If there was a task selected
            
            self.performSegue(withIdentifier: "takeQuizSegue", sender: nil) // The quiz will begin
            
        } else {
            
            // Show popup
            
        }
        
    }
    //Prepare for segue to the quiz
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "takeQuizSegue" {
            
            let quizVC = segue.destination as! IndivualQuizViewController
            
            quizVC.unit = selectedTask // Set the unit the user will be taking a quiz on 
            
        }
        
    }
    

}
