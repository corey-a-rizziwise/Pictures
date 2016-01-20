//
//  friendBloggerTableViewCell.swift
//  Traverse
//
//  Created by Corey Rizzi-Wise on 12/11/15.
//  Copyright © 2015 Samuel Wang. All rights reserved.
//

import UIKit

class friendBloggerTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMetricsLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
