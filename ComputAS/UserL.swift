//
//  UserL.swift
//  ComputAS
//
//  Created by Daniel Turato on 06/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit
import Foundation

class UserL: NSObject, NSCoding {
    
    var ranking: Int
    var id: Int
    var username: String
    var score: Int
    
    // set everything thats needed for a default leaderboard user
    init(ranking: Int, id: Int, username: String, score: Int) {
        
        self.id = id
        self.username = username
        self.score = score
        self.ranking = ranking
        
    }
    // Protocols assinged to NSObject & NSCoding that it needs to run
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeInteger(forKey: "id")
        self.username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
        self.score = aDecoder.decodeInteger(forKey: "score")
        self.ranking = aDecoder.decodeInteger(forKey: "ranking")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(ranking, forKey: "ranking")
    }
    
    
}
