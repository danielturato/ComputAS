//
//  ShowScoreViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 13/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

class ShowScoreViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the score label too the total score
        scoreLabel.text = "\(score!)/10"
    }

    

}
