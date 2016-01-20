//
//  newsfeedTableViewCell.swift
//  Traverse
//
//  Created by Corey Rizzi-Wise on 12/13/15.
//  Copyright © 2015 Samuel Wang. All rights reserved.
//

import UIKit

class newsfeedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userProfileImageButton: UIButton!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var reviewTimeLabel: UILabel!
    @IBOutlet weak var placeNameButton: UIButton!
    @IBOutlet weak var placeLocationLabel: UILabel!
    @IBOutlet weak var placePinButton: UIButton!
    @IBOutlet weak var placeReviewLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var atmosphereLabel: UILabel!
    @IBOutlet weak var atmosphereImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
