//
//  UserDefaultsUpdate.swift
//  ComputAS
//
//  Created by Daniel Turato on 28/01/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import Foundation

extension UserDefaults {

    enum UserDefaultsKeys: String {
    
        case isLoggedIn
    
    }
    
    func setIsLoggedIn(value: Bool) {
    
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    
    }
    
    func isLoggedIn() -> Bool {
    
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    
    }

}
