//
//  navViewController.swift
//  Traverse
//
//  Created by Corey Rizzi-Wise on 11/29/15.
//  Copyright © 2015 Samuel Wang. All rights reserved.
//

import UIKit

class navViewController: UINavigationController {
    
    var currentState = "mainMap"
    var numOfFriendsReviews = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let myMapButton   = UIButton(type: UIButtonType.System)
    let bloggersButton   = UIButton(type: UIButtonType.System)
    let friendsButton   = UIButton(type: UIButtonType.System)
    var toFriendsBloggersMaps = "friends"
    
    let friendNameButton   = UIButton(type: UIButtonType.System)
    let followFriendButton   = UIButton(type: UIButtonType.System)
    let followingFriendButton = UIButton(type: UIButtonType.System)
    
    override func viewDidLayoutSubviews() {
        
        let barShadow = UIImageView(image: UIImage(named: "Main_Map Button Shadow"))
        let barView = UIImageView(image: UIImage(named: "Main_Bottom Buttons Divider.jpg"))
        let barView1 = UIImageView(image: UIImage(named: "Main_Bottom Buttons Divider.jpg"))
        let whiteBottomBar = UIImageView(image: UIImage(named: "whiteBackground.jpeg"))
        let screenWidth = view.frame.size.width
        let screenHeight = self.view.frame.size.height
        let buttonWidth = screenWidth/3 as CGFloat
        //let buttonHeight = 50.0 as CGFloat
        let buttonHeight = screenHeight/14
        let button2X = (screenWidth)/2 - buttonWidth/2
        //Sam or Ahmed help Corey ;-)
        //let navigationBarHeight = navigationController!.navigationBar.frame.size.height as CGFloat
        let navigationBarHeight = screenHeight/10.5 as CGFloat
        
        
        //barShadow.frame = CGRect(x: 0, y: screenHeight-buttonHeight-10, width: screenWidth, height: buttonHeight+1)
        //self.view.addSubview(barShadow)
        //print(screenHeight)
        
        whiteBottomBar.frame = CGRectMake(0,screenHeight-buttonHeight, screenWidth, buttonHeight)
        self.view.addSubview(whiteBottomBar)
        
        bloggersButton.frame = CGRectMake(0, screenHeight-buttonHeight, buttonWidth, buttonHeight)
        bloggersButton.setBackgroundImage(UIImage(named: "Main_Home Button Inactive.jpg"), forState: UIControlState.Normal)
        bloggersButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(bloggersButton)
        
        myMapButton.frame = CGRectMake(button2X, screenHeight-buttonHeight, buttonWidth, buttonHeight)
        myMapButton.setBackgroundImage(UIImage(named: "Main_Map Button Inactive.jpg"), forState: UIControlState.Normal)
        myMapButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(myMapButton)
        
        friendsButton.frame = CGRectMake(screenWidth-buttonWidth, screenHeight-buttonHeight, buttonWidth, buttonHeight)
        friendsButton.setBackgroundImage(UIImage(named: "Main_Friend Button Inactive.jpg"), forState: UIControlState.Normal)
        friendsButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(friendsButton)
        barView.frame = CGRect(x: screenWidth-buttonWidth*1.01, y: screenHeight-buttonHeight, width: 5, height: buttonHeight)
        barView1.frame = CGRect(x: screenWidth-buttonWidth*2.01, y: screenHeight-buttonHeight, width: 5, height: buttonHeight)
        barView.contentMode = .ScaleAspectFit
        barView1.contentMode = .ScaleAspectFit
        bloggersButton.contentMode = .ScaleAspectFit
        myMapButton.contentMode = .ScaleAspectFit
        friendsButton.contentMode = .ScaleAspectFit
        
        self.view.addSubview(barView)
        self.view.addSubview(barView1)
        
        
        if(self.currentState == "friendMap"){
            self.friendsButton.setBackgroundImage(UIImage(named: "Main_Friend Button Active.jpg"), forState: UIControlState.Normal)
        }
        if(self.currentState == "followMap"){
            self.bloggersButton.setBackgroundImage(UIImage(named: "Main_Home Button Active.jpg"), forState: UIControlState.Normal)
        }
        if(self.currentState == "mainMap"){
            self.myMapButton.setBackgroundImage(UIImage(named: "Main_Map Button Active.jpg"), forState: UIControlState.Normal)
            
        }
        
    }
    
    func buttonAction(sender:UIButton!)
    {
        if(sender == self.myMapButton){
            print("myMap tapped")
            glblUser.currentState = "mainMap"

            
            if(currentState != "mainMap"){
                currentState = "mainMap"
                performSegueWithIdentifier("toMainMap", sender: self)
            }
        }
        else if(sender == self.bloggersButton){
            print("bloggerButton tapped")
            currentState = "followMap"
            glblUser.currentState = "followMap"
            //            toFriendsBloggersMaps = "bloggers"
            //            print("house tapped this is the bloggers button")
            //RetrieveNumOfBloggers()
            //performSegueWithIdentifier("toBloggersMap", sender: self)
            self.RetrieveFriendsReviews()
        }
        else if(sender == self.friendsButton){
            print("friendsButton tapped")
            currentState = "friendMap"
            glblUser.currentState = "friendMap"
            //            print("friends tapped")
            //            toFriendsBloggersMaps = "friends"
            RetrieveNumOfBloggers()
            performSegueWithIdentifier("toFriendsMap", sender: self)
        }
    }
    
    
    func RetrieveBlogger(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:Blogger) return a.NickName"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var count = 0
            while(count < glblUser.numOfBloggers){
                print(cypher!.data[0]["a.NickName"]! as! String)
                let nickname = cypher!.data[0]["a.NickName"]! as! String
                let blgr = blogger()
                blgr.nickname = nickname
                blgr.firstName = nickname
                glblUser.bloggers.append(blgr)
                print(glblUser.bloggers.count)
                print(glblUser.bloggers[0])
                count++
            }
            //Ahmed changed this on 12/13/15 to make the friend button load the bloggers list
            self.performSegueWithIdentifier("toFriendsMap", sender: self)
            //self.performSegueWithIdentifier("toBloggersMap", sender: self)
        })
    }
    func RetrieveNumOfBloggers(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:Blogger) return count(a)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.numOfBloggers = cypher!.data[0]["count(a)"]! as! Int
            print(cypher!.data[0]["count(a)"]! as! Int)
            if(glblUser.bloggers.count == 0){
                self.RetrieveBlogger()
            }
            else{
                //self.performSegueWithIdentifier("toBloggersMap", sender: self)
                print("retrieve number of bloggers segue")
            }
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
            self.performSegueWithIdentifier("toNewsfeed", sender: self)
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
    
    func changeImage(recognizer: UITapGestureRecognizer){
        self.bloggersButton.setBackgroundImage(UIImage(named: "whiteBackground.jpeg"), forState: UIControlState.Normal)
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