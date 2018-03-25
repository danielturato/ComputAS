//
//  UserTableViewCell.swift
//  ComputAS
//
//  Created by Daniel Turato on 06/02/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    var user: UserL? {
        
        didSet {
            // Sets the data for the cell
            self.updateUI()
            
        }
        
    }
    // Updates the data to whatever has been recieved from the UserLList
    func updateUI() {
        
        let ranking: Int = (user?.ranking)!
        let username: String = (user?.username)!
        let score: Int = (user?.score)!
        // Changes colour depends on 1st, 2nd, 3rd
        if ranking == 1 {
        
            rankingLabel.textColor = UIColor(red: 0.95, green: 0.61, blue: 0.07, alpha: 1.0)
        
        } else if ranking == 2 {
        
            rankingLabel.textColor = UIColor(red: 0.58, green: 0.65, blue: 0.65, alpha: 1.0)
        
        } else if ranking == 3 {
        
            rankingLabel.textColor = UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0)
        
        } else {
        
            rankingLabel.textColor = UIColor.white
            
        }
        
        rankingLabel.text = String(ranking)
        usernameLabel.text = username
        scoreLabel.text = String(score)
        
    }

}
