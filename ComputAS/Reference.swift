//
//  Reference.swift
//  ComputAS
//
//  Created by Daniel Turato on 12/12/2017.
//  Copyright © 2017 Daniel Turato. All rights reserved.
//

import Foundation
import Firebase

enum DatabaseReference {

    case root
    case users(uid: String)
    

    // MARK: - Public
    
    func reference() -> DatabaseReference {
    
        // return....
    
    }
    
    
    private var rootRef: DatabaseReference {
    
        return reference()
    
    }

}



































