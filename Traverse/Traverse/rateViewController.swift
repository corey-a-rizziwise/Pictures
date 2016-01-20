//
//  rateViewController.swift
//  Traverse
//
//  Created by ahmed moussa on 10/5/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

import UIKit

class rateViewController: UIViewController, UITextViewDelegate {
    
    
    var name = "sampleName"
    var address = "sampleAddress"
    var coordinate = CLLocationCoordinate2D()
    var placeType = "sampleType"
    var phoneNumber = "samplePhoneNumber"
    var id = "sampleID"
    var website =  NSURL()
    var neoID = "NeoID"
    var latitude = "Latitude"
    var longitude = "Longitude"
    var web = "Website"
    var foodRating = 1
    var serviceRating = 1
    var atmoRating = 1
    var nodeID = 0
    var reviewText = "sampleReview"
    
    
    var Place = googlePlace()
    
    var currentPlaceName = "samplePlaceName"
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var placeName: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var FoodRateLabel: UILabel!
    @IBOutlet var ServiceRateLabel: UILabel!
    @IBOutlet var AtmoRateLabel: UILabel!
    
    @IBOutlet var textView: UITextView!
    
    @IBAction func saveReviewButton(sender: UIButton) {
        reviewText = textView.text
        
        //if(id != neoID){
          //  CreatePlaceNode()
            //SaveData({() in
          //  })
        //}
        
        RetrieveData({() in
            if(self.id != self.Place.id)
            {
                self.CreatePlaceNode()
            }
            else{
                print("Do Nothing")
            }
        })
        

    }
    
    @IBAction func FoodRateMinus(sender: UIButton) {
        if(foodRating > 1){
            foodRating--
            FoodRateLabel.text = "\(foodRating)"
        }
        
    }
    @IBAction func FoodRatePlus(sender: UIButton) {
        if(foodRating < 5){
            foodRating++
            FoodRateLabel.text = "\(foodRating)"
        }
    }
    
    @IBAction func serviceRatePlus(sender: UIButton) {
        if(serviceRating < 5){
            serviceRating++
            ServiceRateLabel.text = "\(serviceRating)"
        }
    }
    
    @IBAction func ServiceRateMinus(sender: UIButton) {
        if(serviceRating > 1){
            serviceRating--
            ServiceRateLabel.text = "\(serviceRating)"
        }
    }
    
    @IBAction func AtmoRatePlus(sender: UIButton) {
        if(atmoRating < 5){
            atmoRating++
            AtmoRateLabel.text = "\(atmoRating)"
        }
    }
    @IBAction func AtmoRateMinus(sender: UIButton) {
        if(atmoRating > 1){
            atmoRating--
            AtmoRateLabel.text = "\(atmoRating)"
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
    }
    
    func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FoodRateLabel.text = "\(foodRating)"
        ServiceRateLabel.text = "\(serviceRating)"
        AtmoRateLabel.text = "\(atmoRating)"
        
        textView.clearsOnInsertion = true
        
        placeName.text = Place.name
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        
        /*
        if(Place.placeType == "cafe"){
        
        //cafe plus and minus
        
        }else if(PlaceType == "restaurant" || Place.placeType == "meal_takeaway" || Place.placeType == "street_address" || Place.placeType == "food" || Place.placeType == "grocery_or_supermarket"){
        
        //food plus and minus
        
        }else if(Place.placeType == "bar" || Place.placeType == "night_club"){
        
        //drinks plus and minus
        
        }else if(Place.placeType == "entertainment"){

        //events plus and minus
        
        }else if(Place.placeType == "store" || Place.placeType == "home_goods_store" || Place.placeType == "department_store" || Place.placeType == "clothing_store"){
        
        //retail plus and minus
        
        }
        */
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CreatePlaceNode(){
        print("hit me")
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let x = "label"
        let node = Node()
            self.name = self.Place.name
            self.address = self.Place.address
            self.coordinate = CLLocationCoordinate2DMake(self.Place.coordinate.latitude, self.Place.coordinate.longitude)
            self.placeType = self.Place.placeType
            self.phoneNumber = self.Place.phoneNumber
            self.id = self.Place.id
            self.website = self.Place.website
        node.setProp("ID", propertyValue: self.id)
        node.setProp("Name", propertyValue: self.name)
        node.setProp("Address", propertyValue: self.address)
        //node.setProp("Website", propertyValue: self.website)
        node.setProp("Longitude", propertyValue: self.coordinate.longitude)
        node.setProp("Latitude", propertyValue: self.coordinate.latitude)
        node.setProp("Type", propertyValue: self.placeType)
        node.setProp("Phone Number", propertyValue: self.phoneNumber)
        //node.setProp("Review Text", propertyValue: self.reviewText)
        node.addLabel("" + x)
        
        theo.createNode(node, completionBlock: {(node, error) in
            print("new node \(node)")
            self.InsertAsPlace()
            self.updateData({() in
            })
        });
    }
    //TO DO - ADD ERROR HANDLING FOR WEBSITES
    func RetrieveData(completion: () -> Void){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH(n {ID: '\(Place.id)'}) Return n.Name, n.Latitude, n.Longitude, n.Address, n.ID, n.Website, n.`Phone Number`, n.Type, id(n)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            if (cypher != nil && cypher!.data.count > 0)
            {
                print(cypher!.data[0])
                self.name = cypher!.data[0]["n.Name"]! as! String
                self.address = cypher!.data[0]["n.Address"]! as! String
                //self.latitude = cypher!.data[0]["n.Latitude"]! as! String
                //self.longitude = cypher!.data[0]["n.Longitude"]! as! String
                //self.web = cypher!.data[0]["n.Website"]! as! String
                self.phoneNumber = cypher!.data[0]["n.`Phone Number`"]! as! String
                self.placeType = cypher!.data[0]["n.Type"]! as! String
                self.id = cypher!.data[0]["n.ID"]! as! String
                self.nodeID = cypher!.data[0]["id(n)"]! as! Int
                self.neoID = String(self.nodeID)
                self.AddRelationship()
            }
            else
            {
                self.CreatePlaceNode()
            }
        })
        
    }
    func updateData(completion: () -> Void){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH(n {ID: '\(Place.id)'}) Return n.Name, n.Latitude, n.Longitude, n.Address, n.ID, n.Website, n.`Phone Number`, n.Type, id(n)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            print(cypher!.data[0])
            self.name = cypher!.data[0]["n.Name"]! as! String
            self.address = cypher!.data[0]["n.Address"]! as! String
            //self.latitude = cypher!.data[0]["n.Latitude"]! as! String
            //self.longitude = cypher!.data[0]["n.Longitude"]! as! String
            //self.web = cypher!.data[0]["n.Website"]! as! String
            self.phoneNumber = cypher!.data[0]["n.`Phone Number`"]! as! String
            self.placeType = cypher!.data[0]["n.Type"]! as! String
            self.id = cypher!.data[0]["n.ID"]! as! String
            self.nodeID = cypher!.data[0]["id(n)"]! as! Int
            self.neoID = String(self.nodeID)
            self.AddRelationship()
        })
        
    }
    
    func InsertAsPlace(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match n where id(n) = \(self.nodeID) set n : Place"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
        })
    }
    
    func AddRelationship() {
        
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
        theo.fetchNode("\(self.nodeID)", completionBlock: {(node, error) in
            
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

            relationship.relate(parentNode!, toNode: relatedNode!, type: RelationshipType.REVIEW)
            relationship.setProp("Food", propertyValue: self.foodRating)
            relationship.setProp("Service", propertyValue: self.serviceRating)
            relationship.setProp("Atmosphere", propertyValue: self.atmoRating)
            relationship.setProp("ReviewText", propertyValue: "\(self.textView.text)")
            relationship.setProp("Date: ", propertyValue: "\(dateFormatter.stringFromDate(date))")
            relationship.setProp("Time: ", propertyValue: "\(timeFormatter.stringFromDate(date))")
            
            theo.createRelationship(relationship, completionBlock: {(rel, error) in
                self.setHasReviewsTrue()
                
            })
        })
    }
    func setHasReviewsTrue(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match n where id(n) = \(self.nodeID) set n.HasReviews = 'TRUE' return n"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            self.InsertAsPlace()
            self.performSegueWithIdentifier("toHomeMap", sender: self)
            //print(cypher!.data[0]["averageFood"]!)
        })
    }

    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "backToMoreInfo"){
            let destVC = segue.destinationViewController as! moreInfoViewController
            destVC.Place = self.Place
            }

    }
    override func viewDidLayoutSubviews() {
        backButton.backgroundColor = glblColor.traverseGray
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}