//
//  DisplayErrorViewController.swift
//  ComputAS
//
//  Created by Daniel Turato on 18/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import UIKit

class AuthErrorViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        
        dismiss(animated: true)
        
    }

}
