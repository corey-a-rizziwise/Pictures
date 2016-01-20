//
//  LoginViewController.swift
//  Traverse
//
//  Created by Samuel Wang on 10/2/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import Sodium

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    func removeLessThan() -> String {
        return self.replace("<", replacement: "")
    }
    
    func removeGreaterThan() -> String {
        return self.replace(">", replacement: "")
    }
    
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var scrollView: UIScrollView!
    //var Demail: String
    var email = ""
    var password = ""
    var avgFood = 1
    var avgService = 1
    var avgAtmosphere = 1
    var compare = "password"

    var friendNumberOfPlaces = 0
    var friendNumberOfFollowers = 0
    

    let button   = UIButton(type: UIButtonType.System)
    
    @IBOutlet var emailTextBox: UITextField!
    @IBOutlet var passwordTextBox: UITextField!
    @IBAction func loginPressed(sender: UIButton) {
        
        if(emailTextBox.text!.isEmpty == false && passwordTextBox.text!.isEmpty == false){
            //self.originalCenter =
            email = emailTextBox.text!
            password = passwordTextBox.text!
            
            // Store
            defaults.setObject(email, forKey: "email")
            // Store
            defaults.setObject(password, forKey: "password")
            
            //print("User email is: "+email)
            //print("User password is: "+password)
            //allow the user to login to the map
            //print("Yay you can log in")
            glblUser.loggedIn = true
            DoesUserExist()
            //println(nodePassword)
            
        }
        else{
            //tell the user there is no account for them
            //button.frame = CGRectMake(0, 0, 300, 50)
            let AlertView = UIAlertController(title: "Bruhh..", message: "R U Okay?", preferredStyle: UIAlertControllerStyle.Alert)
            AlertView.addAction(UIAlertAction(title: "Don't Try Again.", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(AlertView, animated: true, completion: nil)
            
            self.view.addSubview(button)
            
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if(glblUser.fromSignUp == 1){
            performSegueWithIdentifier("toWelcome", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let Demail = self.defaults.stringForKey("email")
        {
            
            emailTextBox.text = Demail
            if let Dpassword = self.defaults.stringForKey("password")
            {
                passwordTextBox.text = Dpassword
                
                email = Demail
                password = Dpassword
                if(glblUser.loggedOut == false){
                    glblUser.loggedIn = true
                DoesUserExist()
                }
                //println(nodePassword)
                
            }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func RetrieveNumberPlace(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        
        //let cyperQuery: String = "MATCH (a) WHERE a.Email = '\(email)' MATCH (a:User)-[b:REVIEW]-(c:Place) RETURN count(distinct c)"
        let cyperQuery: String = "match (a)-[b:FOLLOWS]-(c)-[d:REVIEW]-(e:Place) where a.Email = '\(email)' RETURN count(distinct e)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            //glblUser.numOfPlaces = cypher!.data[0]["count(distinct c)"]! as! Int
            glblUser.numOfPlaces = cypher!.data[0]["count(distinct e)"]! as! Int
            self.AppendMap()
            glblUser.loggedIn = true
        })
    }
    func AppendMap(){
        //email = "corey.a.rizziwise@gmai.com"
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:FOLLOWS]-(c)-[d:REVIEW]-(e:Place) where a.Email = '\(email)' return e.ID, e.Name, e.Longitude, e.Latitude, e.Address, e.Type, round(avg(d.Food)), round(avg(d.Service)), round(avg(d.Atmosphere))"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            if(cypher != nil){
                var count = 0
                //does not enter while loop yet.
                while(count < glblUser.numOfPlaces)
                {
                    let Name = cypher!.data[count]["e.Name"]!
                    let ID = cypher!.data[count]["e.ID"]!
                    let Type = cypher!.data[count]["e.Type"]!
                    let Address = cypher!.data[count]["e.Address"]!
                    let Longitude = cypher!.data[count]["e.Longitude"]!
                    let Latitude = cypher!.data[count]["e.Latitude"]!
                    let avgFood = cypher!.data[count]["round(avg(d.Food))"]! as! Int
                    let avgService = cypher!.data[count]["round(avg(d.Service))"]! as! Int
                    let avgAtmosphere = cypher!.data[count]["round(avg(d.Atmosphere))"]! as! Int
                    
                    glblUser.places.append(googlePlace(name: Name as! String, address: Address as! String, coordinate: CLLocationCoordinate2DMake(Latitude as! Double, Longitude as! Double), type: Type as! String, phoneNumber: "", website: NSURL(), id: ID as! String, avgFood: avgFood, avgService: avgService, avgAtmosphere: avgAtmosphere))
                    count++
                }
                self.RetrieveAllUsers()
                //self.RetrievePeopleMetricsPlaces()
            }
            else{
                print("cypher returned nil in the AppendMap function in loginViewController")
            }
            
        })
    }
    
    func RetrieveNumberFriends(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH (a)-[r:FOLLOWS]->(b) where id(a) = \(glblUser.neoID) RETURN count(b)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.numOfFriends = cypher!.data[0]["count(b)"]! as! Int
            
            self.RetrieveFriends()
        })
    }
    func RetrieveFriends(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH (a)-[r:FOLLOWS]->(b) where id(a) = \(glblUser.neoID) RETURN b.FirstName, b.LastName, b.Email, id(b), b.Description"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var counter = 0
            glblUser.friends.removeAll()
            while(counter < glblUser.numOfFriends)
            {
                print(cypher!.data[counter]["b.FirstName"]!)
                print(cypher!.data[counter]["b.LastName"]!)
                print(cypher!.data[counter]["b.Email"]!)
                print(cypher!.data[counter]["id(b)"]!)
                print(cypher!.data[counter]["b.Description"]!)
                let first = cypher!.data[counter]["b.FirstName"] as! String
                let last = cypher!.data[counter]["b.LastName"]! as! String
                let email = cypher!.data[counter]["b.Email"]! as! String
                let nodeID = cypher!.data[counter]["id(b)"]! as! Int
                let description = cypher!.data[counter]["b.Description"]! as! String
                let neoID = String(nodeID)
                
                glblUser.friends.append(friend(firstName: first, lastName: last, email: email, id: neoID, numberOfPlaces: self.friendNumberOfPlaces, numberOfFollowers: self.friendNumberOfFollowers, description: description))
                glblUser.actualEveryone.append(friend(firstName: first, lastName: last, email: email, id: neoID, numberOfPlaces: self.friendNumberOfPlaces, numberOfFollowers: self.friendNumberOfFollowers, description: description))
                counter++
            }
        })
    }
    
    func RetrieveNumberUsers(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH n WHERE n : User return count(n)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.numOfUsers = cypher!.data[0]["count(n)"]! as! Int
            glblUser.loggedIn = true
            
        })
    }
    
    func DoesUserExist(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH(n {Email: '\(email)'}) Return n.Password"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            if (cypher != nil && cypher!.data.count > 0)
            {
                self.password = cypher!.data[0]["n.Password"]! as! String
                let sodium = Sodium()!
                let message = "BiGG\(self.passwordTextBox.text!)WaNGG".dataUsingEncoding(NSUTF8StringEncoding)!
                let h = sodium.genericHash.hash(message)! as! NSMutableData
                var randomOne = ((String(sodium.randomBytes.buf(8)! as! NSMutableData).removeWhitespace()).removeLessThan()).removeGreaterThan()
                let randomTwo = ((String(sodium.randomBytes.buf(8)! as! NSMutableData).removeWhitespace()).removeLessThan()).removeGreaterThan()
                var hashedPassword = ((String(h).removeWhitespace()).removeLessThan()).removeGreaterThan()
                hashedPassword += randomTwo
                randomOne += hashedPassword
                let finalHash = randomOne
                print(finalHash)
                let index = finalHash.startIndex.advancedBy(16)
                let endIndex = finalHash.endIndex.advancedBy(-16)
                self.compare = finalHash[Range(start: index, end: endIndex)]
                print(self.email)
                print(self.password)

                self.RetrieveUserData()
            }
            else{
                let AlertView = UIAlertController(title: "Nice Try!", message: "Notifying cops in 3... 2... 1...", preferredStyle: UIAlertControllerStyle.Alert)
                AlertView.addAction(UIAlertAction(title: "Try Again?", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(AlertView, animated: true, completion: nil)
            }
        })
    }
    
    func RetrieveUserData() -> String
    {
        
        let value = "test"
        var nodeID = 0
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        //let cyperQuery: String = "MATCH(n {n.email = \(email)}) RETURN id(n), n.FirstName"
        //let cyperQuery: String = "MATCH(n {Email: 'corey.a.rizziwise@gmail.com'}) Return n.FirstName, n.LastName"
        let cyperQuery: String = "MATCH(n {Email: '\(email)', Password: '\(self.password)'}) Return n.FirstName, n.LastName, n.Email, n.Password, n.id, id(n), n.Description"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            if (cypher != nil && cypher!.data.count > 0)
            {
                let indexTwo = self.password.startIndex.advancedBy(16)
                let endIndexTwo = self.password.endIndex.advancedBy(-16)
                self.password = self.password[Range(start: indexTwo, end: endIndexTwo)]
                if(self.compare == self.password)
                {
                    glblUser.firstName = cypher!.data[0]["n.FirstName"]! as! String
                    glblUser.lastName = cypher!.data[0]["n.LastName"]! as! String
                    glblUser.pswd = cypher!.data[0]["n.Password"]! as! String
                    //glblUser.id = cypher!.data[0]["n.id"]! as! String
                    glblUser.description = cypher!.data[0]["n.Description"]! as! String
                    glblUser.email = cypher!.data[0]["n.Email"]! as! String
                    nodeID = cypher!.data[0]["id(n)"]! as! Int
                    glblUser.neoID = String(nodeID)
                    glblUser.loggedIn = true
                    self.RetrieveNumberPlace()
                    self.RetrieveNumberUsers()
                    self.RetrieveNumberFriends()
                }
                else{
                    let AlertView = UIAlertController(title: "Nice Try!", message: "Notifying cops in 3... 2... 1...", preferredStyle: UIAlertControllerStyle.Alert)
                    AlertView.addAction(UIAlertAction(title: "Try Again?", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(AlertView, animated: true, completion: nil)
                }
            }
            else{
                let AlertView = UIAlertController(title: "Nice Try!", message: "Notifying cops in 3... 2... 1...", preferredStyle: UIAlertControllerStyle.Alert)
                AlertView.addAction(UIAlertAction(title: "Try Again?", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(AlertView, animated: true, completion: nil)
            }
        })
        return glblUser.pswd
    }
    func RetrieveAllUsers(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH n WHERE n : User RETURN n.FirstName, n.LastName, n.Email, id(n), n.Description"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var counter = 0
            while(counter < glblUser.numOfUsers)
            {
                print(cypher!.data[counter]["n.FirstName"]!)
                print(cypher!.data[counter]["n.LastName"]!)
                print(cypher!.data[counter]["n.Email"]!)
                print(cypher!.data[counter]["id(n)"]!)
                print(cypher!.data[counter]["n.Description"]!)
                let first = cypher!.data[counter]["n.FirstName"] as! String
                let last = cypher!.data[counter]["n.LastName"]! as! String
                let email = cypher!.data[counter]["n.Email"]! as! String
                let nodeID = cypher!.data[counter]["id(n)"]! as! Int
                let description = cypher!.data[counter]["n.Description"]! as! String
                let neoID = String(nodeID)
                
                var userAlreadyFriend = false
                for temp in glblUser.friends{
                    if (email == temp.email){
                        userAlreadyFriend = true
                    }
                    
                }
                if(!userAlreadyFriend){
                    glblUser.everyone.append(friend(firstName: first, lastName: last, email: email, id: neoID, numberOfPlaces: self.friendNumberOfPlaces, numberOfFollowers: self.friendNumberOfFollowers, description: description))
                    glblUser.everyone[glblUser.everyone.count-1].isFriend = false
                    
                    glblUser.actualEveryone.append(friend(firstName: first, lastName: last, email: email, id: neoID, numberOfPlaces: self.friendNumberOfPlaces, numberOfFollowers: self.friendNumberOfFollowers, description: description))
                    glblUser.actualEveryone[glblUser.actualEveryone.count-1].isFriend = false
                }
                counter++
                //self.RetrievePeopleMetricsPlaces()
            }
            self.performSegueWithIdentifier("login", sender: self)
        })
    }
    
//    func RetrievePeopleMetricsPlaces(){
//        
//        let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
//        let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
//        let cyperQuery: String = "match (a:User)-[b:REVIEW]-(c:Place) return a.FirstName,id(a),count(distinct c)"
//        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
//        //let completionBlock: TheoCypherQueryCompletionBlock
//        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
//        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
//            var counter = 0
//            glblUser.friends.removeAll()
//            while(counter < glblUser.numOfFriends)
//            {
//                print(cypher!.data[counter]["a.FirstName"]!)
//                print(cypher!.data[counter]["id(a)"]!)
//                print(cypher!.data[counter]["count(distinct c)"]!)
//                //print(cypher!.data[counter]["id(b)"]!)
//                self.friendNumberOfPlaces = cypher!.data[counter]["count(distinct c)"]! as! Int
//                
//                counter++
//            }
//            self.RetrievePeopleMetricsFollowers()
//        })
//    }
//    
//    func RetrievePeopleMetricsFollowers(){
//        
//        let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
//        let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
//        let cyperQuery: String = "match (a:User)-[b:FOLLOWS]->(c:User) return c.FirstName,id(c),count(distinct b)"
//        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
//        //let completionBlock: TheoCypherQueryCompletionBlock
//        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
//        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
//            var counter = 0
//            glblUser.friends.removeAll()
//            while(counter < glblUser.numOfFriends)
//            {
//                print(cypher!.data[counter]["c.FirstName"]!)
//                print(cypher!.data[counter]["id(c)"]!)
//                print(cypher!.data[counter]["count(distinct b)"]!)
//                //print(cypher!.data[counter]["id(b)"]!)
//                //self.friendNumberOfFollowers = cypher!.data[counter]["count(distinct b)"]! as! Int
//                
//                counter++
//            }
//            self.performSegueWithIdentifier("login", sender: self)
//        })
//    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
