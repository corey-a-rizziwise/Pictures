//
//  tabTableViewController.swift
//  Traverse
//
//  Created by ahmed moussa on 10/1/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//
/*
Overview of Funcitonality:

- Allows user to click on the buttons:"Profile", "My Map", "Friend's Map"
 "Terms & Conditions", "Privacy Policy", "Logout"
*/

import UIKit

//Class tabTableViewController: retrieves users map, friends, bloggers, etc when clicked  
class tabTableViewController: UITableViewController {

    var TableArray = [String]()
    var numOfPlaces = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableArray = ["Profile", "Help", "Tutorial", "Terms & Conditions", "Privacy Policy", "Logout"]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return TableArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Return the number of rows in the section.

            return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("UserDataCell", forIndexPath: indexPath) as! UserInfoTableViewCell
            cell.userName.text = glblUser.firstName + " " + glblUser.lastName
            cell.userEmail.text = glblUser.email
            cell.userPicture.image = UIImage(named: "defaultUserImage.jpg")
            
            cell.userPicture.layer.cornerRadius = cell.userPicture.frame.size.width/3
            cell.userPicture.clipsToBounds = true
            
            return cell
        }
        else if(indexPath.section == 1){
            //RetrieveData()
            let cell = tableView.dequeueReusableCellWithIdentifier("HelpCell", forIndexPath: indexPath)
            cell.textLabel?.text =  TableArray[indexPath.section]
            
            return cell
        }else if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCellWithIdentifier("TutorialCell", forIndexPath: indexPath)
//            if(glblUser.friends.count < 2){
//            }
//            if(glblUser.everyone.count < 2){
//            }
            cell.textLabel?.text =  TableArray[indexPath.section]
            
            return cell
        }
        else if(indexPath.section == 3){
            let cell = tableView.dequeueReusableCellWithIdentifier("TermsConditionsCell", forIndexPath: indexPath) 
            
            cell.textLabel?.text =  TableArray[indexPath.section]
            
            return cell
        }else if(indexPath.section == 4){
            let cell = tableView.dequeueReusableCellWithIdentifier("PrivacyPolicyCell", forIndexPath: indexPath) 
            
            cell.textLabel?.text =  TableArray[indexPath.section]
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("LogoutCell", forIndexPath: indexPath) 
            
            glblUser.loggedOut = true
            cell.textLabel?.text =  TableArray[indexPath.section]
            
            return cell
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            return 300
        }
        else{
            return 50
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if( indexPath.section == 0)
        {
            self.RetrieveCountUserPlaces()
        }
        else if (indexPath.section == 1)
        {
            performSegueWithIdentifier("toHelp", sender: self)
        }
        else if (indexPath.section == 2)
        {
            performSegueWithIdentifier("toTutorial", sender: self)
        }
        else if (indexPath.section == 3)
        {
            performSegueWithIdentifier("toConditions", sender: self)
        }
        else if (indexPath.section == 4)
        {
            performSegueWithIdentifier("toPolicy", sender: self)
        }
        else{
            performSegueWithIdentifier("toStart", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
        if(segue.identifier == "toMyMap"){
            let destVC = segue.destinationViewController as! mapViewController
            destVC.currentState = "myMap"
            //destVC.friend1 = self.traverseUsers[indexPath.row]
            
        }
    }


    func RetrieveData(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        //let cyperQuery: String = "MATCH (n) WHERE n.Email = '\(glblUser.email)' MATCH (n)-[r:REVIEW]-(b) RETURN b.ID, b.Name, b.Longitude, b.Latitude, b.Type, b.Address"
        let cyperQuery: String = "MATCH (n)-[r:REVIEW]-(b) WHERE n.Email = '\(glblUser.email)' RETURN b.ID, b.Name, b.Longitude, b.Latitude, b.Type, b.Address"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var count = 0
            
            //does not enter while loop yet.
            while(count < glblUser.numOfPlaces)
            {
                let Name = cypher!.data[count]["b.Name"]!
                let ID = cypher!.data[count]["b.ID"]!
                let Type = cypher!.data[count]["b.Type"]!
                let Address = cypher!.data[count]["b.Address"]!
                let Longitude = cypher!.data[count]["b.Longitude"]!
                let Latitude = cypher!.data[count]["b.Latitude"]!
                
                print(cypher!.data[count]["b.Name"]!)
                print(cypher!.data[count]["b.ID"]!)
                print(cypher!.data[count]["b.Type"]!)
                print(cypher!.data[count]["b.Address"]!)
                print(cypher!.data[count]["b.Longitude"]!)
                print(cypher!.data[count]["b.Latitude"]!)
            
                glblUser.places.append(googlePlace(name: Name as! String, address: Address as! String, coordinate: CLLocationCoordinate2DMake(Latitude as! Double, Longitude as! Double), type: Type as! String, phoneNumber: "", website: NSURL(), id: ID as! String))
                count++
            }
            //                self.name = cypher!.data[0]["n.Name"]! as! String
        })
        
    }
    
    func RetrieveCountUserPlaces(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:REVIEW]->(c:Place) where id(a) = \(glblUser.neoID) return count(c)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            //glblUser.userPlacesCount = cypher!.data[0]["count(c)"]! as! Int
            glblUser.profilePlacesCount = cypher!.data[0]["count(c)"]! as! Int
            print("This is the global user's neoID: \(glblUser.neoID)")
            print("This is the count of user Places: \(glblUser.userPlacesCount)")
            self.RetrieveCountUserFollowers()
        })
    }
    
    func RetrieveCountUserFollowers(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:FOLLOWS]->(c:User) where id(c) = \(glblUser.neoID) return count(distinct a)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            //glblUser.userCountFollowers = cypher!.data[0]["count(distinct a)"]! as! Int
            glblUser.profileFollowersCount = cypher!.data[0]["count(distinct a)"]! as! Int
            self.RetrieveCountUserFollowing()
        })
    }
    
    func RetrieveCountUserFollowing(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:User)-[b:FOLLOWS]->(c:User) where id(a) = \(glblUser.neoID) return count(distinct c)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            //glblUser.userCountFollowing = cypher!.data[0]["count(distinct c)"]! as! Int
            glblUser.profileFollowingCount = cypher!.data[0]["count(distinct c)"]! as! Int
            glblUser.profileId = glblUser.neoID
            self.performSegueWithIdentifier("toMainUserProfile", sender: self)
        }) 
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
