//
//  userProfileTableViewCell.swift
//  Traverse
//
//  Created by Corey Rizzi-Wise on 1/16/16.
//  Copyright © 2016 Samuel Wang. All rights reserved.
//

import UIKit

class userProfileTableViewCell: UITableViewCell {



    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionTextView: UITextView!
    @IBOutlet weak var placesBackground: UIImageView!
    @IBOutlet weak var placesNumberButton: UIButton!
    @IBOutlet weak var placesTextLabel: UILabel!
    
    
    
    @IBOutlet weak var followersBackground: UIImageView!
    @IBOutlet weak var followersNumberButton: UIButton!
    @IBOutlet weak var followersTextLabel: UILabel!
    
    
    
    @IBOutlet weak var followingBackground: UIImageView!
    @IBOutlet weak var followingNumberButton: UIButton!
    @IBOutlet weak var followingTextLabel: UILabel!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func shareButton(sender: AnyObject) {
    }
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
