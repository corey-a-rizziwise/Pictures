//
//  newsFeedTableViewController.swift
//  Traverse
//
//  Created by Corey Rizzi-Wise on 12/13/15.
//  Copyright © 2015 Samuel Wang. All rights reserved.
//
import UIKit

class newsFeedTableViewController: UITableViewController {
    //var refreshControl:UIRefreshControl!
    //--------segmented control variables
    var segmentedControlSelected = 0
    var segmentedControlState = "friends"//"bloggers
    var segmentedControl = UISegmentedControl()
    
    var numOfGlobalReviews = 0
    var numOfBloggerReviews = 0
    var numOfFriendsReviews = 0
    var numOfMyReviews = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        segmentedControl = UISegmentedControl(items: NSArray(array: ["Global", "Friends", "Bloggers", "Me"]) as [AnyObject])
        segmentedControl.frame = CGRectMake(0, 0, 80, 30)
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: "segmentedControlHasChangedValue:", forControlEvents: UIControlEvents.ValueChanged)
        //segmentedControl.addTarget(self, action: "segmentedControlHasChangedValue:", forControlEvents: UIControlEvents.ValueChanged)
        navigationItem.titleView = segmentedControl
        
        self.refreshControl = UIRefreshControl()
        //self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    func refresh(sender:AnyObject){
        if(segmentedControlState == "Global"){
            RetrieveGlobalWall()
        }
        else if(segmentedControlState == "Friends"){
            RetrieveFriendsWall()
        }
        else if(segmentedControlState == "Bloggers"){
            RetrieveBloggersWall()
        }
        else if(segmentedControlState == "Me"){
            RetrieveMeWall()
        }
    }
    
    func segmentedControlHasChangedValue(sender: UISegmentedControl!){
        print ("segmentedControlHasChangedValue")
        if(sender.selectedSegmentIndex == 0){
            segmentedControlState = "Global"
            self.RetrieveGlobalReviews()
        }
        else if(sender.selectedSegmentIndex == 1){
            segmentedControlState = "Friends"
            self.RetrieveFriendsReviews()
        }
        else if(sender.selectedSegmentIndex == 2){
            segmentedControlState = "Bloggers"
            self.RetrieveBloggersReviews()
        }
        else{
            self.RetrieveMeWall()
            segmentedControlState = "Me"
            self.RetrieveMyReviews()
        }
    
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height/3
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return glblUser.activity.count
    }
    
    
    
    /*
    if(Place.placeType == "cafe"){
   
    }else if(Place.placeType == "restaurant" || Place.placeType == "meal_takeaway" || Place.placeType == "street_address" || Place.placeType == "food" || Place.placeType == "grocery_or_supermarket"){
    
    }else if(Place.placeType == "bar" || Place.placeType == "night_club"){
   
    }else if(Place.placeType == "entertainment"){
 
    }else if(Place.placeType == "store" || Place.placeType == "home_goods_store" || Place.placeType == "department_store" || Place.placeType == "clothing_store" || Place.placeType == "shoe_store"){

    }else{

    }

    */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellHeight = view.frame.height
        let cellWidth = view.frame.width
        let cell = tableView.dequeueReusableCellWithIdentifier("newsfeedCell", forIndexPath: indexPath) as! newsfeedTableViewCell
        /*
        self.mainUserProfilePicture.layer.cornerRadius = self.mainUserProfilePicture.frame.size.width/2
        self.mainUserProfilePicture.clipsToBounds = true
        */
        
        //code actually needed
        cell.userNameButton.setTitle(glblUser.activity[indexPath.row].raterName, forState: UIControlState.Normal)
        cell.placeNameButton.setTitle(glblUser.activity[indexPath.row].placeName, forState: UIControlState.Normal)
        //cell.placeLocationLabel.text = "Come visit \(glblUser.activity[indexPath.row].placeName) and find out!"//glblUser.activity[indexPath.row].type
        cell.placeLocationLabel.text = "\(glblUser.activity[indexPath.row].placeLocation)"
        cell.reviewTimeLabel.text = "\(glblUser.activity[indexPath.row].date) \(glblUser.activity[indexPath.row].time)"
        cell.placeReviewLabel.text = glblUser.activity[indexPath.row].tip//"This place has incredible noms and it is right off the back of Mill for some drinks afterwards"
        
        if(glblUser.activity[indexPath.row].type == "cafe"){
            
            cell.foodImageView.image = UIImage(named:"newSliderCafe\(glblUser.activity[indexPath.row].foodRating).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderCafe\(glblUser.activity[indexPath.row].servRating).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderCafe\(glblUser.activity[indexPath.row].atmoRating).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "cafePin.jpeg"), forState: UIControlState.Normal)
            
        }else if(glblUser.activity[indexPath.row].type == "restaurant" || glblUser.activity[indexPath.row].type == "meal_takeaway" || glblUser.activity[indexPath.row].type == "street_adress" || glblUser.activity[indexPath.row].type == "food" || glblUser.activity[indexPath.row].type == "grocery_or_supermarket"){
            
            cell.foodImageView.image = UIImage(named:"newSliderFood\(glblUser.activity[indexPath.row].foodRating).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderFood\(glblUser.activity[indexPath.row].servRating).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderFood\(glblUser.activity[indexPath.row].atmoRating).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "foodPin.jpeg"), forState: UIControlState.Normal)
            
        }else if(glblUser.activity[indexPath.row].type == "bar" || glblUser.activity[indexPath.row].type == "night_club"){
            
            cell.foodImageView.image = UIImage(named:"newSliderDrinks\(glblUser.activity[indexPath.row].foodRating).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderDrinks\(glblUser.activity[indexPath.row].servRating).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderDrinks\(glblUser.activity[indexPath.row].atmoRating).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "drinksPin.jpeg"), forState: UIControlState.Normal)
            
        }else if(glblUser.activity[indexPath.row].type == "entertainment"){
            
            cell.foodImageView.image = UIImage(named:"newSliderEvents\(glblUser.activity[indexPath.row].foodRating).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderEvents\(glblUser.activity[indexPath.row].servRating).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderEvents\(glblUser.activity[indexPath.row].atmoRating).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "eventsPin.jpeg"), forState: UIControlState.Normal)
            
        }else if(glblUser.activity[indexPath.row].type == "store" || glblUser.activity[indexPath.row].type == "home_goods_store" || glblUser.activity[indexPath.row].type == "clothing_store" || glblUser.activity[indexPath.row].type == "shoe_store"){
            
            cell.foodImageView.image = UIImage(named:"newSliderRetail\(glblUser.activity[indexPath.row].foodRating).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderRetail\(glblUser.activity[indexPath.row].servRating).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderRetail\(glblUser.activity[indexPath.row].atmoRating).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "retailPin.jpeg"), forState: UIControlState.Normal)
            
        }else{
            
            cell.foodImageView.image = UIImage(named:"newSliderEvents\(glblUser.activity[indexPath.row].foodRating).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderEvents\(glblUser.activity[indexPath.row].servRating).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderEvents\(glblUser.activity[indexPath.row].atmoRating).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "eventsPin.jpeg"), forState: UIControlState.Normal)
            
        }
        
        return cell
    }
    func RetrieveGlobalWall(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:REVIEW]-(c:Place) return a.FirstName,a.LastName,b.Time,b.Date,b.ReviewText,b.Food,b.Service,b.Atmosphere,c.Name,c.Type,c.Address order by b.Date ascending, b.Time ascending"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var counter = 0
            var reviewCount = 0
            glblUser.activity.removeAll()
            while(counter < 100 && reviewCount < self.numOfGlobalReviews)
            {
                let first = cypher!.data[reviewCount]["a.FirstName"] as! String
                let last = cypher!.data[reviewCount]["a.LastName"]! as! String
                let date = cypher!.data[reviewCount]["b.Date"]! as! String
                let time = cypher!.data[reviewCount]["b.Time"]! as! String
                let review = cypher!.data[reviewCount]["b.ReviewText"]! as! String
                let food = cypher!.data[reviewCount]["b.Food"]! as! Int
                let service = cypher!.data[reviewCount]["b.Service"]! as! Int
                let atmosphere = cypher!.data[reviewCount]["b.Atmosphere"]! as! Int
                let placeName = cypher!.data[reviewCount]["c.Name"]! as! String
                let type = cypher!.data[reviewCount]["c.Type"]! as! String
                let address = cypher!.data[reviewCount]["c.Address"]! as! String
                
                glblUser.activity.append(newsFeed(raterName: "\(first) \(last)", placeName: placeName, tip: review, time: time, date: date, foodRating: food, atmoRating: atmosphere, servRating: service, type: type, placeLocation: address))
                counter++
                reviewCount++
            }
            self.refreshControl!.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func RetrieveFriendsWall(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:FOLLOWS]-(c:User)-[d:REVIEW]-(e:Place) where id(a) = \(glblUser.neoID) return c.FirstName,c.LastName,d.Time,d.Date,d.ReviewText,d.Food,d.Service,d.Atmosphere,e.Name,e.Type,e.Address order by d.Date ascending, d.Time ascending"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var counter = 0
            var numOfReviews = 0
            glblUser.activity.removeAll()
            while(counter < 100 && numOfReviews < self.numOfFriendsReviews)
            {
                let first = cypher!.data[numOfReviews]["c.FirstName"] as! String
                let last = cypher!.data[numOfReviews]["c.LastName"]! as! String
                let date = cypher!.data[numOfReviews]["d.Date"]! as! String
                let time = cypher!.data[numOfReviews]["d.Time"]! as! String
                let review = cypher!.data[numOfReviews]["d.ReviewText"]! as! String
                let food = cypher!.data[numOfReviews]["d.Food"]! as! Int
                let service = cypher!.data[numOfReviews]["d.Service"]! as! Int
                let atmosphere = cypher!.data[numOfReviews]["d.Atmosphere"]! as! Int
                let placeName = cypher!.data[numOfReviews]["e.Name"]! as! String
                let type = cypher!.data[numOfReviews]["e.Type"]! as! String
                let address = cypher!.data[numOfReviews]["e.Address"]! as! String
                
                glblUser.activity.append(newsFeed(raterName: "\(first) \(last)", placeName: placeName, tip: review, time: time, date: date, foodRating: food, atmoRating: atmosphere, servRating: service, type: type, placeLocation: address))
                counter++
                numOfReviews++
            }
            self.refreshControl!.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func RetrieveBloggersWall(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:Blogger)-[b:REVIEW]-(c:Place) return a.FirstName,a.LastName,b.Time,b.Date,b.ReviewText,b.Food,b.Service,b.Atmosphere,c.Name,c.Type,c.Address order by b.Date ascending, b.Time ascending"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var counter = 0
            var numOfReviews = 0
            glblUser.activity.removeAll()
            while(counter < 100 && numOfReviews < self.numOfBloggerReviews)
            {
                let first = cypher!.data[numOfReviews]["a.FirstName"] as! String
                let last = cypher!.data[numOfReviews]["a.LastName"]! as! String
                let date = cypher!.data[numOfReviews]["b.Date"]! as! String
                let time = cypher!.data[numOfReviews]["b.Time"]! as! String
                let review = cypher!.data[numOfReviews]["b.ReviewText"]! as! String
                let food = cypher!.data[numOfReviews]["b.Food"]! as! Int
                let service = cypher!.data[numOfReviews]["b.Service"]! as! Int
                let atmosphere = cypher!.data[numOfReviews]["b.Atmosphere"]! as! Int
                let placeName = cypher!.data[numOfReviews]["c.Name"]! as! String
                let type = cypher!.data[numOfReviews]["c.Type"]! as! String
                let address = cypher!.data[numOfReviews]["c.Address"]! as! String
                
                glblUser.activity.append(newsFeed(raterName: "\(first) \(last)", placeName: placeName, tip: review, time: time, date: date, foodRating: food, atmoRating: atmosphere, servRating: service, type: type, placeLocation: address))
                counter++
                numOfReviews++
            }
            self.refreshControl!.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func RetrieveMeWall(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:REVIEW]-(c:Place) where id(a) = \(glblUser.neoID) return a.FirstName,a.LastName,b.Time,b.Date,b.ReviewText,b.Food,b.Service,b.Atmosphere,c.Name,c.Type,c.Address order by b.Date ascending, b.Time ascending"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var counter = 0
            var numOfReviews = 0
            glblUser.activity.removeAll()
            while(counter < 100 && numOfReviews < self.numOfMyReviews)
            {
                let first = cypher!.data[numOfReviews]["a.FirstName"] as! String
                let last = cypher!.data[numOfReviews]["a.LastName"]! as! String
                let date = cypher!.data[numOfReviews]["b.Date"]! as! String
                let time = cypher!.data[numOfReviews]["b.Time"]! as! String
                let review = cypher!.data[numOfReviews]["b.ReviewText"]! as! String
                let food = cypher!.data[numOfReviews]["b.Food"]! as! Int
                let service = cypher!.data[numOfReviews]["b.Service"]! as! Int
                let atmosphere = cypher!.data[numOfReviews]["b.Atmosphere"]! as! Int
                let placeName = cypher!.data[numOfReviews]["c.Name"]! as! String
                let type = cypher!.data[numOfReviews]["c.Type"]! as! String
                let address = cypher!.data[numOfReviews]["c.Address"]! as! String
                
                glblUser.activity.append(newsFeed(raterName: "\(first) \(last)", placeName: placeName, tip: review, time: time, date: date, foodRating: food, atmoRating: atmosphere, servRating: service, type: type, placeLocation: address))
                counter++
                numOfReviews++
            }
            self.refreshControl!.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func RetrieveGlobalReviews(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:REVIEW]-(c:Place) return count(b)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            self.numOfGlobalReviews = cypher!.data[0]["count(b)"]! as! Int
            self.RetrieveGlobalWall()
        })
    }
    
    func RetrieveBloggersReviews(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:Blogger)-[b:REVIEW]-(c:Place) return count(b)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            self.numOfBloggerReviews = cypher!.data[0]["count(b)"]! as! Int
            self.RetrieveBloggersWall()
        })
    }
    
    func RetrieveFriendsReviews(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:FOLLOWS]-(c:User)-[d:REVIEW]-(e:Place) where id(a) = \(glblUser.neoID) return count(d)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            self.numOfFriendsReviews = cypher!.data[0]["count(d)"]! as! Int
            self.RetrieveFriendsWall()
        })
    }
    
    func RetrieveMyReviews(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:REVIEW]-(c:Place) where id(a) = \(glblUser.neoID) return count(b)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            self.numOfMyReviews = cypher!.data[0]["count(b)"]! as! Int
            self.RetrieveMeWall()
        })
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
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
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
