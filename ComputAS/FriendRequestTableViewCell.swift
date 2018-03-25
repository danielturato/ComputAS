//
//  FriendRequestTableViewCell.swift
//  ComputAS
//
//  Created by Daniel Turato on 14/03/2018.
//  Copyright © 2018 Daniel Turato. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var request: FriendRequest? {
        
        didSet {
            // Make sure each rows shows the correct data
            self.updateUI()
            
        }
        
    }
    
    func updateUI() {
        
        usernameLabel.text = request?.username
        
        
    }
}
