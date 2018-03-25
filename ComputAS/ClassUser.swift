//
//  ClassUser.swift
//  ComputAS
//
//  Created by Daniel Turato on 02/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Foundation

class ClassUser: NSObject, NSCoding { // ClassUser inherits and goes by these protocols for a later data
    
    var id: Int
    var username: String
    var score: Int
    
    init(id: Int, username: String, score: Int) {
        
        self.id = id
        self.username = username
        self.score = score
        
    }
    
    required init(coder aDecoder: NSCoder) { // Requires this constructor
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
        self.score = aDecoder.decodeInteger(forKey: "score")
    }
    
    func encode(with aCoder: NSCoder) { // Required in the protocol 
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(score, forKey: "score")
    }
    
}






