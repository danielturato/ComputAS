//
//  ClassTaskTableViewCell.swift
//  ComputAS
//
//  Created by Daniel Turato on 03/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import SwiftyPlistManager

class ClassTaskTableViewCell: UITableViewCell {

    // Outlets connecting to the view
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    
    var task: Task? { // Requires a Task to be set
        didSet { // If the task is set, the UI will update
            self.updateUI()
        }
    }
    
    // Method to update the UI according to the Task
    func updateUI() {
        
        taskTitleLabel.text = task?.name
        var name = task?.name as! String
        name = name.trimmingCharacters(in: ["[", "]", "?"])
        name = name.removingWhitespaces()
        name = name.trimmingCharacters(in: .letters)
        name = name.trimmingCharacters(in: .whitespaces)
        name.remove(at: name.index(before: name.endIndex))
        guard case let completion as Bool = SwiftyPlistManager.shared.fetchValue(for: "\(name)", fromPlistWithName: "UnitFourTwo") else { return }
        
        let green: UIColor = UIColor(red: 0.18, green: 0.80, blue: 0.44, alpha: 1.0)
        
        if completion == true {
            
            completeLabel.backgroundColor = green
            
        }
        
    }
    
    
    
    
}
