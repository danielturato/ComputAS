//
//  RequiredInfoViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 18/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import UIKit
// This is linked with the error display, will run everytime an error occurs in the program
class RequiredInfoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
   
    @IBAction func closeButtonDidTap(_ sender: Any) {
        
        dismiss(animated: true)
        
    }
    
}
