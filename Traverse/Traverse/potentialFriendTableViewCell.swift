//
//  potentialFriendTableViewCell.swift
//  Traverse
//
//  Created by Corey Rizzi-Wise on 12/13/15.
//  Copyright © 2015 Samuel Wang. All rights reserved.
//

import UIKit

class potentialFriendTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMetricsLabel: UILabel!
    @IBOutlet weak var followFriendButton: UIButton!
    
    
    @IBAction func followFriendButtonClicked(sender: UIButton) {
        if(!glblUser.everyone[followFriendButton.tag].isFriend){
                AddFriendRelationship()
                glblUser.numOfFriends++
                glblUser.friends.append(glblUser.everyone[followFriendButton.tag])
            //            followFriendButton.setBackgroundImage(UIImage(named: "alreadyFriend.jpg"), forState: UIControlState.Normal)
            //            glblUser.everyone[followFriendButton.tag].isFriend = true
            //            print(followFriendButton.tag)
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func AddFriendRelationship() {
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        
        /**
         * Setup dispatch group since you to make a 2 part transation
         */
        
        let nodeFetchQueueName: String = "com.theo.node.fetch.queue"
        let fetchDispatchGroup: dispatch_group_t = dispatch_group_create()
        
        var parentNode: Node?
        var relatedNode: Node?
        let relationship: Relationship = Relationship()
        
        /**
        * Fetch the parent node
        */
        
        dispatch_group_enter(fetchDispatchGroup)
        theo.fetchNode("\(glblUser.neoID)", completionBlock: {(node, error) in
            
            print("meta in success \(node!.meta) node \(node) error \(error)")
            
            if let nodeObject: Node = node {
                parentNode = nodeObject
            }
            
            dispatch_group_leave(fetchDispatchGroup)
        })
        
        /**
        * Fetch the related node
        */
        
        dispatch_group_enter(fetchDispatchGroup)
        theo.fetchNode("\(glblUser.everyone[self.followFriendButton.tag].id)", completionBlock: {(node, error) in
            
            print("meta in success \(node!.meta) node \(node) error \(error)")
            
            if let nodeObject: Node = node {
                relatedNode = nodeObject
            }
            
            dispatch_group_leave(fetchDispatchGroup)
        })
        
        /**
        * End it
        */
        
        dispatch_group_notify(fetchDispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            let timeFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.stringFromDate(date)
            timeFormatter.stringFromDate(date)
            print(dateFormatter.stringFromDate(date))
            print(timeFormatter.stringFromDate(date))
            relationship.relate(parentNode!, toNode: relatedNode!, type: RelationshipType.FOLLOWS)
            relationship.setProp("Date: ", propertyValue: "\(dateFormatter.stringFromDate(date))")
            relationship.setProp("Time: ", propertyValue: "\(timeFormatter.stringFromDate(date))")
            theo.createRelationship(relationship, completionBlock: {(rel, error) in
                
                self.followFriendButton.setBackgroundImage(UIImage(named: "alreadyFriend.jpg"), forState: UIControlState.Normal)
                glblUser.everyone[self.followFriendButton.tag].isFriend = true
                print(self.followFriendButton.tag)
                
                //self.performSegueWithIdentifier("toHomeMap", sender: self)
            })
        })
    }
    
    
    
}
