//
//  LearnTableViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 16/01/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

class LearnTableViewController: UITableViewController { // Class inherits from UITableViewController 
    
    // Outlets connecting to the learn table view
    @IBOutlet weak var learnButton: UIButton!
    @IBOutlet weak var fourTwoLabel: UILabel!
    @IBOutlet weak var fourThree: UILabel!
    @IBOutlet weak var fourFive: UILabel!
    @IBOutlet weak var fourSix: UILabel!
    @IBOutlet weak var fourSeven: UILabel!
    @IBOutlet weak var fourNine: UILabel!
    @IBOutlet weak var fourTen: UILabel!
    @IBOutlet weak var fourEleven: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design for menu button
        learnButton.addBottomBorderWithColour(colour: UIColor.white, width: 1.5)
        
    }
}
