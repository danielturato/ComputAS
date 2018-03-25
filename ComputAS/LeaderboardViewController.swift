//
//  LeaderboardViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 06/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController {

    @IBOutlet weak var learderBoardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        learderBoardButton.addBottomBorderWithColour(colour: UIColor.white, width: 1.5)

        
    }


}
