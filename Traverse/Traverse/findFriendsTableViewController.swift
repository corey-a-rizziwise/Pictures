//
//  findFriendsTableViewController.swift
//  Traverse
//
//  Created by ahmed moussa on 10/16/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

import UIKit

extension findFriendsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class findFriendsTableViewController: UITableViewController {
    
    var traverseUsers = [friend]()
    var filteredTraverseUsers = [friend]()
    var selectedPotentialFriend = friend()
    let searchController = UISearchController(searchResultsController: nil)
    var MainUserProfileViewController: mainUserProfileViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        print(traverseUsers)
//        traverseUsers.append(friend(firstName: "Sam", lastName: "Wang"))
//        traverseUsers.append(friend(firstName: "Corey", lastName: "Rizzi-Wise"))
//        traverseUsers.append(friend(firstName: "Colby", lastName: "jack cheese"))
//        traverseUsers.append(friend(firstName: "Ahmed", lastName: "Moussa"))
        traverseUsers.append(friend())
        //
        //------UINavigationBar make the text say
        //
        self.navigationItem.title = "Search for Friends"
        self.navigationController?.navigationBar.tintColor = glblColor.activeBlue
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        if let splitViewController = splitViewController {
            let controllers = splitViewController.viewControllers
            MainUserProfileViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? mainUserProfileViewController
        }
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        //clearsSelectionOnViewWillAppear = splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTraverseUsers = glblUser.everyone.filter { user in
            let fullName = "\(user.firstName) \(user.lastName)"
            return fullName.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.active && searchController.searchBar.text != "") {
            return filteredTraverseUsers.count
        }
        else{
            if(section == 0){
                return glblUser.everyone.count
            }
            else{
                return 1
            }
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
        //let cell = tableView.dequeueReusableCellWithIdentifier("potentialFriendCell", forIndexPath: indexPath) as! findFriendBloggerTableViewCell
        let userFilter : friend
        if (searchController.active && searchController.searchBar.text != "") {
            userFilter = filteredTraverseUsers[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("potentialFriendCell2", forIndexPath: indexPath) as! potentialFriendTableViewCell
            
            cell.userNameLabel.text = "\(userFilter.firstName) \(userFilter.lastName)"
            cell.userProfileImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            cell.self.userProfileImage.layer.cornerRadius = cell.self.userProfileImage.layer.frame.width/2
            cell.self.userProfileImage.clipsToBounds = true
            //cell.userMetricsLabel.text = " 6 places - 80 followers"
            //cell.userMetricsLabel.text = "\(glblUser.friend1.placesCount) places - \(glblUser.friend1.countFollowers) followers"
            cell.userMetricsLabel.text = " "
            cell.userMetricsLabel.font = UIFont(name: cell.userMetricsLabel.font.fontName, size: 9)
            
            //----------------      ahmed's playing around with images begins
            cell.followFriendButton.tag = indexPath.row
            if(userFilter.isFriend){
                cell.followFriendButton.setBackgroundImage(UIImage(named: "alreadyFriend.jpg"), forState: UIControlState.Normal)
            }
            else{
                cell.followFriendButton.setBackgroundImage(UIImage(named: "addFriend.jpg"), forState: UIControlState.Normal)
            }
            
            //----------------      ahmed's playing around with images ends
            
            return cell
        }
        else{
            if(indexPath.section == 0){
                let cell = tableView.dequeueReusableCellWithIdentifier("potentialFriendCell2", forIndexPath: indexPath) as! potentialFriendTableViewCell
                
                //cell.textLabel?.text = "\(glblUser.everyone[indexPath.row].firstName) \(glblUser.everyone[indexPath.row].lastName)"
                
                cell.userNameLabel.text = "\(glblUser.everyone[indexPath.row].firstName) \(glblUser.everyone[indexPath.row].lastName)"
                cell.userProfileImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                cell.self.userProfileImage.layer.cornerRadius = cell.self.userProfileImage.layer.frame.width/2
                cell.self.userProfileImage.clipsToBounds = true
                //cell.userMetricsLabel.text = " 6 places - 80 followers"
                //cell.userMetricsLabel.text = "\(glblUser.friend1.placesCount) places - \(glblUser.friend1.countFollowers) followers"
                cell.userMetricsLabel.text = " "
                cell.userMetricsLabel.font = UIFont(name: cell.userMetricsLabel.font.fontName, size: 9)
                
                //----------------      ahmed's playing around with images begins
                cell.followFriendButton.tag = indexPath.row
                if(glblUser.everyone[indexPath.row].isFriend){
                    cell.followFriendButton.setBackgroundImage(UIImage(named: "alreadyFriend.jpg"), forState: UIControlState.Normal)
                }
                else{
                    cell.followFriendButton.setBackgroundImage(UIImage(named: "addFriend.jpg"), forState: UIControlState.Normal)
                }
                
                //----------------      ahmed's playing around with images ends
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
                
                cell.textLabel?.text = ""
                
                return cell
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if( indexPath.section == 0)
        {
            if (searchController.active && searchController.searchBar.text != ""){
                self.selectedPotentialFriend = filteredTraverseUsers[indexPath.row]
                glblUser.friendName = ("\(String(self.selectedPotentialFriend.firstName)) \(String(self.selectedPotentialFriend.lastName))")
                glblUser.friendID = Int(selectedPotentialFriend.id)!
                glblUser.friendEmail = selectedPotentialFriend.email
                self.RetrieveCountFriendFollowers()
            }
            else{
                self.selectedPotentialFriend = glblUser.everyone[indexPath.row]
                
                glblUser.friendName = ("\(String(self.selectedPotentialFriend.firstName)) \(String(self.selectedPotentialFriend.lastName))")
                glblUser.friendID = Int(selectedPotentialFriend.id)!
                glblUser.friendEmail = selectedPotentialFriend.email
                
                self.RetrieveCountFriendPlaces()
            }

        }
        }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            //
            //Change height of first cell for table view controller
            //
            return 60
        }
        else{
            return 50
        }
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
        if(segue.identifier == "toPotentialFriendProfile"){
            
            let destVC = segue.destinationViewController as! mainUserProfileViewController
            
            destVC.currentState = "potentialFriendProfile"
            destVC.friend1 = selectedPotentialFriend//glblUser.everyone[indexPath.row]//glblUser.friends[indexPath.row]
            glblUser.friend1 = selectedPotentialFriend
            glblUser.currentState = "potentialFriendMap"
            }
        if(segue.identifier == "toFollowMap"){
            //let destVC = segue.destinationViewController as! mapViewController
            //destVC.currentState = "potentialFriendMap"
            //destVC.friend1 = glblUser.everyone[indexPath.row]
            glblUser.friend1 = glblUser.everyone[indexPath.row]
            glblUser.currentState = "potentialFriendMap"
        }
        
    }
    

    func RetrieveCountFriendPlaces(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:REVIEW]->(c:Place) where id(a) = \(selectedPotentialFriend.id) return count(distinct c)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.friendPlacesCount = cypher!.data[0]["count(distinct c)"]! as! Int
            self.selectedPotentialFriend.placesCount = cypher!.data[0]["count(distinct c)"]! as! Int
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
        let cyperQuery: String = "match (a:User)-[b:FOLLOWS]->(c:User) where id(c) = \(selectedPotentialFriend.id) return count(distinct a)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.friendCountFollowers = cypher!.data[0]["count(distinct a)"]! as! Int
            self.selectedPotentialFriend.countFollowers = cypher!.data[0]["count(distinct a)"]! as! Int
            self.RetrieveCountFriendFollowing()
        })
    }
    
    func RetrieveCountFriendFollowing(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:FOLLOWS]->(c:User) where id(a) = \(selectedPotentialFriend.id) return count(distinct c)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.friendCountFollowing = cypher!.data[0]["count(distinct c)"]! as! Int
            self.selectedPotentialFriend.countFollowing = cypher!.data[0]["count(distinct c)"]! as! Int
            print("hit me plz")
            self.performSegueWithIdentifier("toPotentialFriendProfile", sender: self)
        })
    }

}
