//
//  AlertController.swift
//  ComputAS
//
//  Created by Daniel Turato on 15/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import UIKit


func createAlert(title: String, message: String) {

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        
        alert.dismiss(animated: true, completion: nil)
        
    }))
    
    alert.present(alert, animated: true, completion: nil)
}














