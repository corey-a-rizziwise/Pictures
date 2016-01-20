//
//  friendsMapsTableViewController.swift
//  Traverse
//
//  Created by ahmed moussa on 10/10/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

import UIKit

class friendsMapsTableViewController: UITableViewController {
    
    var selectedFriend = friend()
    var destinationFriendName = "sampleFriendName"
    var bloggersfriends = "friends" // or "bloggerMaps"
    
    var currentBlogger = blogger()
    var name = ""
    var latitude = 0.0
    var longitude = 0.0
    var address = ""
    var type = ""
    var ID = ""
    //--------segmented control variables
    var segmentedControlSelected = 0
    var segmentedControlState = "friends"//"bloggers
    var segmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        segmentedControl = UISegmentedControl(items: NSArray(array: ["Friends", "Bloggers"]) as [AnyObject])
        segmentedControl.frame = CGRectMake(0, 0, 80, 30)
        segmentedControl.selectedSegmentIndex = segmentedControlSelected
        //self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        segmentedControl.addTarget(self, action: "segmentedControlHasChangedValue:", forControlEvents: UIControlEvents.ValueChanged)
        navigationItem.titleView = segmentedControl
        
        
    }
    func segmentedControlHasChangedValue(sender: UISegmentedControl!){
        print ("segmentedControlHasChangedValue")
        if(sender.selectedSegmentIndex == 0){
            segmentedControlState = "friends"
            self.tableView.reloadData()
        }
        else{
            segmentedControlState = "bloggers"
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        else if(section == 1){
            if(bloggersfriends == "bloggerMaps"){
                return glblUser.bloggers[0].maps.count
            }
            else if(segmentedControlState == "bloggers"){
                return glblUser.bloggers.count
            }
            else{
                return glblUser.friends.count
            }
            
        }
        else{
            return 1
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! friendsMapsHeaderTableViewCell
            
            if(bloggersfriends == "bloggerMaps"){
                cell.backgroundColor = glblColor.traverseGray
                cell.textLabel?.text = "Blogger Places"
                cell.textLabel?.textColor = glblColor.activeBlue
                cell.textLabel?.backgroundColor = glblColor.traverseGray
                
            }
            else if(segmentedControlState == "bloggers"){
                cell.backgroundColor = glblColor.traverseGray
                cell.textLabel?.text = "List of Bloggers"
                cell.textLabel?.textColor = glblColor.activeBlue
                cell.textLabel?.backgroundColor = glblColor.traverseGray
            }
            else{
                cell.backgroundColor = glblColor.traverseGray
                cell.textLabel?.text = "Click to Search for Friends"
                cell.textLabel?.textColor = glblColor.activeBlue
                cell.textLabel?.backgroundColor = glblColor.traverseGray
            }
            return cell
        }
        else if(indexPath.section == 1){
            if(bloggersfriends == "bloggerMaps" || segmentedControlState == "bloggers"){
                let cell = tableView.dequeueReusableCellWithIdentifier("bloggerCell", forIndexPath: indexPath)
                
                if(bloggersfriends == "bloggerMaps"){
                    //cell.textLabel?.text = glblUser.bloggers[0].maps[indexPath.row].name
                    cell.textLabel?.text = glblUser.bloggers[0].maps[indexPath.row].name
                }
                else if(segmentedControlState == "bloggers"){
                    cell.textLabel?.text = glblUser.bloggers[indexPath.row].firstName//"Blogger \(indexPath.row)"
                }
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("friendBloggerTableViewCell", forIndexPath: indexPath) as! friendBloggerTableViewCell
                
                
                //cell.textLabel?.text = glblUser.friends[indexPath.row].firstName + " " + glblUser.friends[indexPath.row].lastName
                cell.userNameLabel.text = glblUser.friends[indexPath.row].firstName + " " + glblUser.friends[indexPath.row].lastName
                cell.userProfileImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                cell.self.userProfileImage.layer.cornerRadius = cell.self.userProfileImage.layer.frame.width/2
                cell.self.userProfileImage.clipsToBounds = true
                //cell.userMetricsLabel.text = "6 places - 80 followers"
                //cell.userMetricsLabel.text = "\(glblUser.friend1.placesCount) places - \(glblUser.friend1.countFollowers) followers"
                cell.userMetricsLabel.text = " "
                cell.userMetricsLabel.font = UIFont(name: cell.userMetricsLabel.font.fontName, size: 9)
                
                return cell
            }
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! friendsMapsHeaderTableViewCell
            
            cell.textLabel?.text = " "
            return cell
        }
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 0 && segmentedControlState == "friends"){
            performSegueWithIdentifier("toFindFriend", sender: self)
        }
        if( indexPath.section == 1 && segmentedControlState == "friends")
        {
            if(bloggersfriends != "bloggerMaps"){
                self.selectedFriend = glblUser.friends[indexPath.row]
                glblUser.friendName = ("\(String(self.selectedFriend.firstName)) \(String(self.selectedFriend.lastName))")
                glblUser.friendID = Int(selectedFriend.id)!
                glblUser.friendEmail = selectedFriend.email
                self.RetrieveCountFriendPlaces()
            }
            else{
                performSegueWithIdentifier("toBloggerMapPlaces", sender: self)
            }
        }
        else if(indexPath.section == 1 && segmentedControlState == "bloggers"){
            print("clicked blogger cell in segmentedControl FriendMapView")
            RetrieveNumCustomMap()
            //self.performSegueWithIdentifier("toBloggerMaps", sender: self)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            //
            //Change height of first cell for table view controller
            //This is the cell that holds "Click to Search for Friends"
            //
            //return 150
            return 50
        }
        else{
            return 60
        }
    }
    
    func RetrieveCountFriendPlaces(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:REVIEW]->(c:Place) where id(a) = \(selectedFriend.id) return count(c)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.friendPlacesCount = cypher!.data[0]["count(c)"]! as! Int
            glblUser.profilePlacesCount = cypher!.data[0]["count(c)"]! as! Int
            self.selectedFriend.placesCount = cypher!.data[0]["count(c)"]! as! Int
            print("This is the global user's neoID: \(glblUser.friendID)")
            print("This is the count of user Places: \(glblUser.friendPlacesCount)")
            self.RetrieveCountFriendFollowers()
        })
    }
    
    func RetrieveCountFriendFollowers(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:FOLLOWS]->(c:User) where id(c) = \(selectedFriend.id) return count(distinct a)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.friendCountFollowers = cypher!.data[0]["count(distinct a)"]! as! Int
            glblUser.profileFollowersCount = cypher!.data[0]["count(distinct a)"]! as! Int
            self.selectedFriend.countFollowers = cypher!.data[0]["count(distinct a)"]! as! Int
            self.RetrieveCountFriendFollowing()
        })
    }
    
    func RetrieveCountFriendFollowing(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:FOLLOWS]->(c:User) where id(a) = \(selectedFriend.id) return count(distinct c)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.friendCountFollowing = cypher!.data[0]["count(distinct c)"]! as! Int
            glblUser.profileFollowingCount = cypher!.data[0]["count(distinct c)"]! as! Int
            self.selectedFriend.countFollowing = cypher!.data[0]["count(distinct c)"]! as! Int
            print("hit me plz")
            self.performSegueWithIdentifier("toFriendProfile", sender: self)
        })
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
        if(segue.identifier == "toFriendProfile"){
            
            let destVC = segue.destinationViewController as! mainUserProfileViewController
            
            destVC.currentState = "friendProfile"
            destVC.friend1 = selectedFriend//glblUser.friends[indexPath.row]
            glblUser.friend1 = selectedFriend
            glblUser.currentState = "friendMap"
            glblUser.profileId = selectedFriend.id
            
        }
        if(segue.identifier == "toBloggerMapPlaces"){
            
            let destVC = segue.destinationViewController as! mapViewController
            
            destVC.currentState = "followMap"
            destVC.currentBlogger = glblUser.bloggers[0]
            destVC.currentBloggerMapNo = indexPath.row
            glblUser.currentState = "followMap"
            
        }
        if(segue.identifier == "toBloggerMaps"){
            let destVC = segue.destinationViewController as! BloggersTableViewController
            destVC.state = "segmentedControlPlaces"
        }
    }
    
    
    func RetrieveNumCustomMap(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:Blogger)-[b:REVIEW]-(c:Place) return count(DISTINCT b.CustomMap)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.bloggers[0].numOfBCustomMaps = cypher!.data[0]["count(DISTINCT b.CustomMap)"]! as! Int
            //glblUser.bloggers[0].numOfBCustomMaps = 2
            //glblUser.bloggers[0].numOfBCustomMapPlaces = cypher!.data[0]["count(distinct c.ID)"]! as! Int
            print("number of blogger maps!!!:::: \(glblUser.bloggers[0].numOfBCustomMaps)")
            if(glblUser.bloggers[0].maps.count == 0){
                self.RetrieveNumCustomMapPlaces()
            }else{
                self.performSegueWithIdentifier("toBloggerMaps", sender: self)
            }
        })
    }
    func RetrieveNumCustomMapPlaces(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:Blogger)-[b:REVIEW]-(c:Place) return DISTINCT b.CustomMap, count(b.CustomMap)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            //print(cypher!.data[0]["DISTINCT b.CustomMap"]! as! String)
            print(cypher)
            var mapCount = 0
            while(mapCount < glblUser.bloggers[0].numOfBCustomMaps){
                glblUser.bloggers[0].maps.append(map(name: cypher!.data[mapCount]["b.CustomMap"]! as! String))//"ahmed"))//
                mapCount++
            }
            var count = 0
            while(count < glblUser.bloggers[0].maps.count)
            {
                glblUser.bloggers[0].maps[count].numOfPlaces = cypher!.data[count]["count(b.CustomMap)"]! as! Int
                print("map: \(glblUser.bloggers[0].maps[count].name) has \(glblUser.bloggers[0].maps[count].numOfPlaces) places")
                count++
            }
            //self.RetrieveCustomMap()
            self.performSegueWithIdentifier("toBloggerMaps", sender: self)
        })
    }
    
}
