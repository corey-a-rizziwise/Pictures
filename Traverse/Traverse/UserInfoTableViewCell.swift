//
//  UserInfoTableViewCell.swift
//  Traverse
//
//  Created by ahmed moussa on 10/1/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet var userPicture: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
