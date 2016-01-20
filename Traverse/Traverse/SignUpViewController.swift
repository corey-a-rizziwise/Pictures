//
//  SignUpViewController.swift
//  Traverse
//
//  Created by Samuel Wang on 10/2/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//
/*
Overview of Funcitonality:

- Creates person in database after they sign up
- Get access to data on places
- Assign tips to user's saved locations
*/


import UIKit
import Sodium

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    //var userLongitude = 0.0
    //var userLatitude = 0.0
    //var array = ["string1", "string2", "string3"]
    let button   = UIButton(type: UIButtonType.System)
    
    @IBOutlet var firstNameTextBox: UITextField!
    @IBOutlet var lastNameTextBox: UITextField!
    @IBOutlet var emailTextBox: UITextField!
    @IBOutlet var passwordTextBox: UITextField!
    @IBOutlet var confirmPasswordTextBox: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBAction func SubmitButton(sender: UIButton) {
        print(firstName+"\n"+lastName+"\n"+email+"\n"+password+"\n"+confirmPassword)
        password = passwordTextBox.text!
        confirmPassword = confirmPasswordTextBox.text!
        if(password != confirmPassword)
        {
            print("Passwords did not match.")
            //errorLabel.text = "Passwords did not match."
            //tell the user there is no account for them
            print("You shall not pass")
            
            button.frame = CGRectMake(0, 0, 300, 50)
            button.backgroundColor = UIColor.darkGrayColor()
            button.setTitle("must input username/password", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(button)
        }
        else{
            if(firstNameTextBox.text!.isEmpty == false && lastNameTextBox.text!.isEmpty == false && emailTextBox.text!.isEmpty == false && passwordTextBox.text!.isEmpty == false && confirmPasswordTextBox.text!.isEmpty == false){
                firstName = firstNameTextBox.text!
                lastName = lastNameTextBox.text!
                email = emailTextBox.text!
                password = passwordTextBox.text!
                confirmPassword = confirmPasswordTextBox.text!
                print(email)
                email = email.lowercaseString
                
                
                DoesExist()
            }
            else{
                let AlertView = UIAlertController(title: "Bruhhh...", message: "Are You Okay?", preferredStyle: UIAlertControllerStyle.Alert)
                AlertView.addAction(UIAlertAction(title: "Don't Try Again.", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(AlertView, animated: true, completion: nil)
                self.view.addSubview(button)
            }
        }
        print(firstName+"\n"+lastName+"\n"+email+"\n"+password+"\n"+confirmPassword)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField == emailTextBox || textField == passwordTextBox || textField == confirmPasswordTextBox){
            scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        CreateUserNode()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toMap"){
            glblUser.fromSignUp = 1
        }
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func CreateUserNode(completion: () -> Void){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let node = Node()
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        let timeFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.stringFromDate(date)
        timeFormatter.stringFromDate(date)
        
        let sodium = Sodium()!
        let message = "BiGG\(passwordTextBox.text!)WaNGG".dataUsingEncoding(NSUTF8StringEncoding)!
        let h = sodium.genericHash.hash(message)! as! NSMutableData
        var randomOne = ((String(sodium.randomBytes.buf(8)! as! NSMutableData).removeWhitespace()).removeLessThan()).removeGreaterThan()
        let randomTwo = ((String(sodium.randomBytes.buf(8)! as! NSMutableData).removeWhitespace()).removeLessThan()).removeGreaterThan()
        var hashedPassword = ((String(h).removeWhitespace()).removeLessThan()).removeGreaterThan()
        hashedPassword += randomTwo
        randomOne += hashedPassword
        let finalHash = randomOne
        print(finalHash)
        
        //node.setProp("PracticeArray", propertyValue: array)
        node.setProp("Email", propertyValue: email)
        node.setProp("FirstName", propertyValue: firstName)
        node.setProp("LastName", propertyValue: lastName)
        node.setProp("Password", propertyValue: finalHash)
        node.setProp("Description", propertyValue: "Photographer. Explorer. Foody. I love Traverse!")
        node.setProp("Time", propertyValue: "\(timeFormatter.stringFromDate(date))")
        node.setProp("Date", propertyValue: "\(dateFormatter.stringFromDate(date))")
        
        theo.createNode(node, completionBlock: {(node, error) in
            print("new node \(node)")
            self.SaveData({() in
            })
        });
        glblUser.loggedIn = true
    }
    
    func InsertAsUser(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match n where id(n) = \(glblUser.neoID) set n : User"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            self.FollowSelf()
            
        })
    }
    
    func SaveData(completion: () -> Void){
        var nodeID = 0
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH(n {Email: '\(email)'}) Return n.FirstName, n.LastName, n.Email, n.Password, n.id, id(n)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.firstName = cypher!.data[0]["n.FirstName"]! as! String
            glblUser.lastName = cypher!.data[0]["n.LastName"]! as! String
            glblUser.email = cypher!.data[0]["n.Email"]! as! String
            glblUser.pswd = cypher!.data[0]["n.Password"]! as! String
            nodeID = cypher!.data[0]["id(n)"]! as! Int
            glblUser.neoID = String(nodeID)
            print(glblUser.neoID)
            print(nodeID)
            self.InsertAsUser()
        })
        glblUser.loggedIn = true
    }
    
    func DoesExist(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH(n {Email: '\(emailTextBox.text!)'}) Return n.Email"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            if (cypher != nil && cypher!.data.count > 0)
            {
                let AlertView = UIAlertController(title: "Nice Try!", message: "This email already has an existing account.", preferredStyle: UIAlertControllerStyle.Alert)
                AlertView.addAction(UIAlertAction(title: "Try Again?", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(AlertView, animated: true, completion: nil)
            }
            else{
                self.CreateUserNode({ () in
                    glblUser.loggedIn = true
                })
            }
        })
    }
    
    func FollowSelf() {
        
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
        theo.fetchNode("\(glblUser.neoID)", completionBlock: {(node, error) in
            
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
            
            relationship.relate(parentNode!, toNode: relatedNode!, type: RelationshipType.FOLLOWS)
            relationship.setProp("Date", propertyValue: "\(dateFormatter.stringFromDate(date))")
            relationship.setProp("Time", propertyValue: "\(timeFormatter.stringFromDate(date))")
            //
            //----------pass the longitude and latitiude to this view controller
            //
            
            theo.createRelationship(relationship, completionBlock: {(rel, error) in
                self.performSegueWithIdentifier("toMap", sender: self)
            })
        })
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}