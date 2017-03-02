//
//  UserTableViewCell.swift
//  ReQuit
//
//  Created by Winston Van on 11/27/16.
//  Copyright © 2016 Winston Van. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    

    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
