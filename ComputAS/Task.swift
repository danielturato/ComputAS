//
//  Task.swift
//  ComputAS
//
//  Created by Daniel Turato on 02/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Foundation

class Task: NSObject, NSCoding { // Class inherits from these to enable to save an array of this object later on
    
    var name: String
    
    init(name: String) {
        
        self.name = name
        
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }
    
    
}





