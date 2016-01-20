//
//  mainUserProfileViewController.swift
//  Traverse
//
//  Created by Corey Rizzi-Wise on 10/28/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//
/*
Overview of Funcitonality:

- Displays user's profile page from user profile folder
*/

import UIKit

class mainUserProfileViewController: UITableViewController {
    
    
    var friend1 = friend()
    var currentState = "mainProfile"
    
    var firstNameToGeneric = [String]()
    var lastNameToGeneric = [String]()
    
    var placeNameToGeneric = [String]()
    var placeAddressToGeneric = [String]()
    var placeTypeToGeneric = [String]()
    
    var reviewDateToGeneric = [String]()
    var reviewTimeToGeneric = [String]()
    var reviewTextToGeneric = [String]()
    var foodToGeneric = [Int]()
    var serviceToGeneric = [Int]()
    var atmoToGeneric = [Int]()
    
    
    
    
    var selectedButton = "places" //following //followers
    
    //general user data
    @IBOutlet weak var mainUserProfilePicture: UIImageView!
    @IBOutlet weak var mainUserFirstNameLabel: UILabel!
    @IBOutlet weak var mainUserLastNameLabel: UILabel!
    @IBOutlet weak var mainUserEmailLabel: UILabel!
    @IBOutlet weak var mainUserTraverseLogo: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func shareButton(sender: AnyObject) {
        var shareText = "Check out my \(glblUser.profilePlacesCount) reviews on Traverse!" as NSString
        var shareWebsite = NSURL(string: "http://www.traversemobile.co/")
        
        //let itemsToShare = [
        //    "Check out my \(glblUser.profilePlacesCount) reviews on Traverse!" as NSString
        //]
        
        let itemsToShare = [shareText, shareWebsite!]
        
        let activityController = UIActivityViewController(
                    activityItems: itemsToShare,
                    applicationActivities:[StringReverserActivity()])
        
                presentViewController(activityController, animated: true, completion: nil)
    }
    
    //metrics
    
    @IBOutlet weak var numberOfPlacesButton: UIButton!
    
    @IBAction func numberOfPlacesClicked(sender: UIButton) {
        RetrievePlacesAndSegueToGenericTable()
        selectedButton = "places"
    }
    
    
    @IBOutlet var numberOfFollwersButton: UIButton!
    @IBAction func numberOfFollowersClicked(sender: UIButton) {
        RetrieveFollowersAndSegueToGenericTable()
        selectedButton = "followers"
    }
    
    @IBOutlet weak var numberOfFollowingButton: UIButton!
    
    @IBAction func numberOfFollowingClicked(sender: UIButton) {
        RetrieveFollowingAndSegueToGenericTable()
        selectedButton = "following"
    }
    
    
    @IBOutlet weak var toMap: UIButton!
    @IBAction func ToMap(sender: UIButton) {
        if(currentState == "mainProfile"){
            //RetrieveNumberOfPlacesOfUser()
            print("won't work cause messed up")
        }
        else{
            RetrieveNumberPlaceFriends()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height/2
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellHeight = view.frame.height
        let cellWidth = view.frame.width
        let cell = tableView.dequeueReusableCellWithIdentifier("userProfileCell", forIndexPath: indexPath) as! userProfileTableViewCell
        
        cell.placesBackground.layer.cornerRadius = cell.placesBackground.frame.size.width/12
        cell.placesBackground.clipsToBounds = true
        cell.followersBackground.layer.cornerRadius = cell.followersBackground.frame.size.width/12
        cell.followersBackground.clipsToBounds = true
        cell.followingBackground.layer.cornerRadius = cell.followingBackground.frame.size.width/12
        cell.followingBackground.clipsToBounds = true
        
        if(currentState == "mainProfile"){
        cell.userNameLabel.text = "\(glblUser.firstName) \(glblUser.lastName)"
        cell.userDescriptionTextView.text = "\(glblUser.description)"
        cell.placesNumberButton.setTitle(String(glblUser.profilePlacesCount), forState: UIControlState.Normal)
        cell.followersNumberButton.setTitle(String(glblUser.profileFollowersCount), forState: UIControlState.Normal)
        cell.followingNumberButton.setTitle(String(glblUser.profileFollowingCount), forState: UIControlState.Normal)
        cell.userDescriptionTextView.text = glblUser.description
        }else if(currentState == "friendProfile"){
        cell.userNameLabel.text = "\(friend1.firstName) \(friend1.lastName)"
        cell.userDescriptionTextView.text = "\(friend1.description)"
        cell.placesNumberButton.setTitle(String(friend1.placesCount), forState: UIControlState.Normal)
        cell.followersNumberButton.setTitle(String(friend1.countFollowers), forState: UIControlState.Normal)
        cell.followingNumberButton.setTitle(String(friend1.countFollowers), forState: UIControlState.Normal)
        cell.backButton.alpha = 0.0
        }else if(currentState == "potentialFriendProfile"){
        cell.userNameLabel.text = "\(friend1.firstName) \(friend1.lastName)"
        cell.userDescriptionTextView.text = "\(friend1.description)"
        cell.placesNumberButton.setTitle(String(friend1.placesCount), forState: UIControlState.Normal)
        cell.followersNumberButton.setTitle(String(friend1.countFollowers), forState: UIControlState.Normal)
        cell.followingNumberButton.setTitle(String(friend1.countFollowers), forState: UIControlState.Normal)
        cell.backButton.alpha = 0.0
        }
        
        return cell
    }

    
    override func viewDidLayoutSubviews() {
//        if(currentState == "mainProfile"){
//            //make the user profile picture round
//            self.mainUserProfilePicture.layer.cornerRadius = self.mainUserProfilePicture.frame.size.width/2
//            self.mainUserProfilePicture.clipsToBounds = true
//            
//            //set the user first name, last name, and email
//            mainUserFirstNameLabel.text = "\(glblUser.firstName) \(glblUser.lastName)"
//            //mainUserLastNameLabel.text = "\(glblUser.lastName)"
//            //mainUserEmailLabel.text = "\(glblUser.email)"
//            
//            //
//            //corner radius of To Map buttton
//            //
//            toMap.layer.cornerRadius = toMap.frame.size.width/30
//            
//            //change the button UI
//            backButton.backgroundColor = glblColor.traverseGray
//            
//            //set user metrics
//            numberOfPlacesButton.setTitle(String(glblUser.profilePlacesCount), forState: UIControlState.Normal)
//            numberOfFollwersButton.setTitle(String(glblUser.profileFollowersCount), forState: UIControlState.Normal)
//            numberOfFollowingButton.setTitle(String(glblUser.profileFollowingCount), forState: UIControlState.Normal)
//            
//            
//            //numberOfPlaces.text = String(glblUser.userPlacesCount)
//            //numberOfFollowers.text = String(glblUser.userCountFollowers)
//            //numberOfFollowing.text = String(glblUser.userCountFollowing)
//        }
//        else if(currentState == "friendProfile")
//        {
//            self.mainUserProfilePicture.layer.cornerRadius = self.mainUserProfilePicture.frame.size.width/2
//            self.mainUserProfilePicture.clipsToBounds = true
//            mainUserFirstNameLabel.text = glblUser.friendName
//            backButton.backgroundColor = glblColor.traverseGray
//            
//            
//            numberOfPlacesButton.setTitle(String(friend1.placesCount), forState: UIControlState.Normal)
//            numberOfFollowingButton.setTitle(String(friend1.countFollowing), forState: UIControlState.Normal)
//            numberOfFollwersButton.setTitle(String(friend1.countFollowers), forState: UIControlState.Normal)
//            
//            //numberOfPlaces.text = String(friend1.placesCount)//String(glblUser.friendPlacesCount)
//            //numberOfFollowers.text = String(friend1.countFollowers)//String(glblUser.friendCountFollowers)
//            //numberOfFollowing.text = String(friend1.countFollowing)//String(glblUser.friendCountFollowing)
//            toMap.layer.cornerRadius = toMap.frame.size.width/30
//            backButton.alpha = 0
//        }
//        else if (currentState == "potentialFriendProfile")
//        {
//            self.mainUserProfilePicture.layer.cornerRadius = self.mainUserProfilePicture.frame.size.width/2
//            self.mainUserProfilePicture.clipsToBounds = true
//            mainUserFirstNameLabel.text = glblUser.friendName
//            backButton.backgroundColor = glblColor.traverseGray
//            
//            numberOfPlacesButton.setTitle(String(friend1.placesCount), forState: UIControlState.Normal)
//            numberOfFollowingButton.setTitle(String(friend1.countFollowing), forState: UIControlState.Normal)
//            numberOfFollwersButton.setTitle(String(friend1.countFollowers), forState: UIControlState.Normal)
//            
//            //numberOfPlaces.text = String(friend1.placesCount)//String(glblUser.friendPlacesCount)
//            //numberOfFollowers.text = String(friend1.countFollowers)//String(glblUser.friendCountFollowers)
//            //numberOfFollowing.text = String(friend1.countFollowing)//String(glblUser.friendCountFollowing)
//            toMap.layer.cornerRadius = toMap.frame.size.width/30
//            backButton.alpha = 0
//        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toFriendMap"){
            
            let destVC = segue.destinationViewController as! mapViewController
            
            destVC.currentState = "friendMap"
            destVC.friend1 = friend1//glblUser.friends[indexPath.row]
        }
        else if(segue.identifier == "toPotentialFriendMap"){
            
            let destVC = segue.destinationViewController as! mapViewController
            
            destVC.currentState = "potentialFriendMap"
            destVC.friend1 = friend1//glblUser.friends[indexPath.row]
        }
        else if (segue.identifier == "toMyMap"){
            let destVC = segue.destinationViewController as! mapViewController
            
            destVC.currentState = "myMap"
            destVC.friend1 = friend1
        }
        else if(segue.identifier == "toBloggerMapPlaces"){
            
            let destVC = segue.destinationViewController as! mapViewController
            
            destVC.currentState = "followMap"
            destVC.currentBlogger = glblUser.bloggers[0]
        }
        if(segue.identifier == "toGenericTable"){
            
            let destVC = segue.destinationViewController as! genericTableViewController
            destVC.firstName = firstNameToGeneric
            destVC.lastName = lastNameToGeneric
            
            destVC.placeName = placeNameToGeneric
            destVC.placeAddress = placeAddressToGeneric
            destVC.placeType = placeTypeToGeneric
            
            destVC.reviewDate = reviewDateToGeneric
            destVC.reviewTime = reviewTimeToGeneric
            destVC.reviewText = reviewTextToGeneric
            destVC.foodRating = foodToGeneric
            destVC.serviceRating = serviceToGeneric
            destVC.atmoRating = atmoToGeneric
        
            destVC.state = selectedButton

        }
    }

    
    func RetrieveNumberPlaceFriends(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH (n) WHERE n.Email = '\(glblUser.friendEmail)' MATCH (n)-[r:REVIEW]-(b) RETURN count(DISTINCT b)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.friendPlaces = cypher!.data[0]["count(DISTINCT b)"]! as! Int
            self.RetrieveFriendsMap()
        })
    }
    
    func RetrieveFriendsMap(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:REVIEW]-(c:Place) where id(a) = \(glblUser.friendID) return c.Name, c.Latitude, c.Longitude, c.Address, c.Type, c.ID, round(avg(b.Food)), round(avg(b.Service)), round(avg(b.Atmosphere))"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var count = 0
            
            //does not enter while loop yet.
            while(count < glblUser.friendPlaces)
            {
                print(cypher!.data[count]["c.Name"]!)
                print(cypher!.data[count]["c.Latitude"]!)
                print(cypher!.data[count]["c.Longitude"]!)
                print(cypher!.data[count]["c.Address"]!)
                print(cypher!.data[count]["c.Type"]!)
                let name = cypher!.data[count]["c.Name"]! as! String
                let latitude = cypher!.data[count]["c.Latitude"]! as! Double
                let longitude = cypher!.data[count]["c.Longitude"]! as! Double
                let address = cypher!.data[count]["c.Address"]! as! String
                let type = cypher!.data[count]["c.Type"]! as! String
                let ID = cypher!.data[count]["c.ID"]! as! String
                let avgFood = cypher!.data[count]["round(avg(b.Food))"]! as! Int
                let avgService = cypher!.data[count]["round(avg(b.Service))"]! as! Int
                let avgAtmosphere = cypher!.data[count]["round(avg(b.Atmosphere))"]! as! Int
                
                
                self.friend1.places.append(googlePlace(name: name, address: address, coordinate: CLLocationCoordinate2DMake(latitude, longitude), type: type, phoneNumber: "", website: NSURL(), id: ID, avgFood: avgFood, avgService: avgService, avgAtmosphere: avgAtmosphere))
                
                count++
            }
            if (self.currentState == "mainProfile"){
                //self.performSegueWithIdentifier("toMyMap", sender: self)
            }
            else if (self.currentState == "friendProfile")
            {
                self.performSegueWithIdentifier("toFriendMap", sender: self)
            }
            else if (self.currentState == "potentialFriendProfile")
            {
                self.performSegueWithIdentifier("toPotentialFriendMap", sender: self)
            }
        })
    }
    //
    //-----------this appears to be working correctly except what happens when I view the main profile as a friends profile?
    //
    func RetrieveNumberOfPlacesOfUser(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH (n) WHERE n.Email = '\(glblUser.email)' MATCH (n)-[r:REVIEW]-(b) RETURN count(DISTINCT b)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.friendPlaces = cypher!.data[0]["count(DISTINCT b)"]! as! Int
            self.RetrieveUsersMap()
        })
    }
    
    func RetrieveUsersMap(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:REVIEW]-(c:Place) where id(a) = \(glblUser.neoID) return c.Name, c.Latitude, c.Longitude, c.Address, c.Type, c.ID, round(avg(b.Food)), round(avg(b.Service)), round(avg(b.Atmosphere))"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var count = 0
            
            //does not enter while loop yet.
            while(count < glblUser.friendPlaces)
            {
                print(cypher!.data[count]["c.Name"]!)
                print(cypher!.data[count]["c.Latitude"]!)
                print(cypher!.data[count]["c.Longitude"]!)
                print(cypher!.data[count]["c.Address"]!)
                print(cypher!.data[count]["c.Type"]!)
                let name = cypher!.data[count]["c.Name"]! as! String
                let latitude = cypher!.data[count]["c.Latitude"]! as! Double
                let longitude = cypher!.data[count]["c.Longitude"]! as! Double
                let address = cypher!.data[count]["c.Address"]! as! String
                let type = cypher!.data[count]["c.Type"]! as! String
                let ID = cypher!.data[count]["c.ID"]! as! String
                let avgFood = cypher!.data[count]["round(avg(b.Food))"]! as! Int
                let avgService = cypher!.data[count]["round(avg(b.Service))"]! as! Int
                let avgAtmosphere = cypher!.data[count]["round(avg(b.Atmosphere))"]! as! Int
                
                
                self.friend1.places.append(googlePlace(name: name, address: address, coordinate: CLLocationCoordinate2DMake(latitude, longitude), type: type, phoneNumber: "", website: NSURL(), id: ID, avgFood: avgFood, avgService: avgService, avgAtmosphere: avgAtmosphere))
                
                count++
            }
            self.performSegueWithIdentifier("toMyMap", sender: self)
        })
    }

    
    func RetrieveFollowersAndSegueToGenericTable(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:FOLLOWS]->(c:User) where id(c) = \(glblUser.profileId) return a.FirstName, a.LastName"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var counter = 0
            self.firstNameToGeneric.removeAll()
            self.lastNameToGeneric.removeAll()
            if(glblUser.profileId == glblUser.neoID)
            {
                print("BOB")
                //self.firstNameToGeneric.append("Click to Go Back")
                //self.lastNameToGeneric.append(" ")
            }
            //self.dataToGeneric.append("Back")
            while(counter < glblUser.profileFollowersCount)
            {
                print(cypher!.data[counter]["a.FirstName"]!)
                print(cypher!.data[counter]["a.LastName"]!)
                let first = cypher!.data[counter]["a.FirstName"] as! String
                let last = cypher!.data[counter]["a.LastName"]! as! String
                
                self.firstNameToGeneric.append(first)
                self.lastNameToGeneric.append(last)
                counter++
            }
            self.performSegueWithIdentifier("toGenericTable", sender: self)
        })
    }
    //
    //-----------this appears to be working correctly except what happens when I view the main profile as a friends profile?
    //
    func RetrieveFollowingAndSegueToGenericTable(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:FOLLOWS]->(c:User) where id(a) = \(glblUser.profileId) return c.FirstName, c.LastName"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var counter = 0
            self.firstNameToGeneric.removeAll()
            self.lastNameToGeneric.removeAll()
            print("LALA")
            //self.dataToGeneric.append("Back")
            print("LALA\(self.friend1.countFollowing)")
            //while(counter < glblUser.numOfFriends)
            if(glblUser.profileId == glblUser.neoID)
            {
                //NEED THESE BACK BUTTON PUT IN
                //self.firstNameToGeneric.append("Back")
                //self.lastNameToGeneric.append("Back")
            }
            while(counter < glblUser.profileFollowingCount)
            {
                print(cypher!.data[counter]["c.FirstName"]!)
                print(cypher!.data[counter]["c.LastName"]!)
                let first = cypher!.data[counter]["c.FirstName"] as! String
                let last = cypher!.data[counter]["c.LastName"]! as! String
                
                self.firstNameToGeneric.append(first)
                self.lastNameToGeneric.append(last)
                counter++
            }
            self.performSegueWithIdentifier("toGenericTable", sender: self)
        })
    }
 
    func RetrievePlacesAndSegueToGenericTable(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:REVIEW]-(c:Place) where id(a) = \(glblUser.profileId) return a.FirstName, a.LastName, c.Name, c.Type, c.Address, b.Food, b.Service, b.Atmosphere, b.ReviewText, b.Date, b.Time"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var counter = 0

            self.firstNameToGeneric.removeAll()
            self.lastNameToGeneric.removeAll()
            
            self.placeNameToGeneric.removeAll()
            self.placeAddressToGeneric.removeAll()
            self.placeTypeToGeneric.removeAll()
            
            self.reviewDateToGeneric.removeAll()
            self.reviewTimeToGeneric.removeAll()
            self.reviewTextToGeneric.removeAll()
            self.foodToGeneric.removeAll()
            self.serviceToGeneric.removeAll()
            self.atmoToGeneric.removeAll()
            
            if(glblUser.profileId == glblUser.neoID)
            {
                print("BOB")
                //NEED BACK BUTTON PUT IN
                //self.firstNameToGeneric.append("Back")
                //self.lastNameToGeneric.append("Back")
            }
            //self.dataToGeneric.append("Back")
            while(counter < glblUser.profilePlacesCount)
            {
                let firstName = cypher!.data[counter]["a.FirstName"] as! String
                let lastName = cypher!.data[counter]["a.LastName"] as! String
                let placeName = cypher!.data[counter]["c.Name"] as! String
                let placeAddress = cypher!.data[counter]["c.Address"] as! String
                let placeType = cypher!.data[counter]["c.Type"] as! String
                let reviewText = cypher!.data[counter]["b.ReviewText"] as! String
                let reviewDate = cypher!.data[counter]["b.Date"] as! String
                let reviewTime = cypher!.data[counter]["b.Time"] as! String
                let foodRating = cypher!.data[counter]["b.Food"]! as! Int
                let serviceRating = cypher!.data[counter]["b.Service"]! as! Int
                let atmoRating = cypher!.data[counter]["b.Atmosphere"]! as! Int

                self.firstNameToGeneric.append(firstName)
                self.lastNameToGeneric.append(lastName)
                self.placeNameToGeneric.append(placeName)
                self.placeAddressToGeneric.append(placeAddress)
                self.placeTypeToGeneric.append(placeType)
                self.reviewTextToGeneric.append(reviewText)
                self.reviewDateToGeneric.append(reviewDate)
                self.reviewTimeToGeneric.append(reviewTime)
                self.foodToGeneric.append(foodRating)
                self.serviceToGeneric.append(serviceRating)
                self.atmoToGeneric.append(atmoRating)
                
                counter++
            }
            self.performSegueWithIdentifier("toGenericTable", sender: self)
        })
    }
    
    
}
