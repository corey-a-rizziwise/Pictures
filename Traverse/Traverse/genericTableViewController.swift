//
//  genericTableViewController.swift
//  Traverse
//
//  Created by ahmed moussa on 12/19/15.
//  Copyright © 2015 Samuel Wang. All rights reserved.
//

import UIKit

class genericTableViewController: UITableViewController {

    var data = [String]()
    var state = "places" //following //followers 
    
    var firstName = [String]()
    var lastName = [String]()
    
    var placeName = [String]()
    var placeAddress = [String]()
    var placeType = [String]()
    
    var reviewDate = [String]()
    var reviewTime = [String]()
    var reviewText = [String]()
    var foodRating = [Int]()
    var serviceRating = [Int]()
    var atmoRating = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("This is the state you are in: \(state)")
        print("User Name: \(firstName) \(lastName)")
        print("placeName: \(placeName)")
        print("placeAddress: \(placeAddress)")
        print("placeType: \(placeType)")
        print("reviewDate: \(reviewDate)")
        print("reviewTime: \(reviewTime)")
        print("reviewText: \(reviewText)")
        print("F: \(foodRating) S:\(serviceRating) A: \(atmoRating)")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstName.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(glblUser.profileId == glblUser.neoID){
            if(indexPath.section == 0){
                performSegueWithIdentifier("toUserProfile", sender: self)
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(state == "places"){
         return view.frame.height/3
        }else if(state == "followers"){
            return 60
            //return view.frame.height/4
        }else if(state == "following"){
            return 60
            //return view.frame.height/4
        }else{
            return 60
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(state == "places"){
            /*
            let cell = tableView.dequeueReusableCellWithIdentifier("genericCell", forIndexPath: indexPath)
            
            cell.textLabel?.text = "Places \(data[indexPath.row])"
            
            return cell
            */
            let cellHeight = view.frame.height
            let cellWidth = view.frame.width
            let cell = tableView.dequeueReusableCellWithIdentifier("newsfeedCell", forIndexPath: indexPath) as! newsfeedTableViewCell
            
            
            //code actually needed
            cell.userNameButton.setTitle("\(firstName[indexPath.row]) \(lastName[indexPath.row])", forState: UIControlState.Normal)
            cell.placeNameButton.setTitle("\(placeName[indexPath.row])", forState: UIControlState.Normal)
            cell.placeLocationLabel.text = "\(placeAddress[indexPath.row])"
            cell.reviewTimeLabel.text = "\(reviewDate[indexPath.row]) \(reviewTime[indexPath.row])"
            cell.placeReviewLabel.text = "\(reviewText[indexPath.row])" //"This place has incredible noms and it is right off the back of Mill for some drinks afterwards"
            
            if(placeType[indexPath.row] == "cafe"){
                
                cell.foodImageView.image = UIImage(named:"newSliderCafe\(foodRating[indexPath.row]).jpeg")
                cell.serviceImageView.image = UIImage(named:"newSliderCafe\(serviceRating[indexPath.row]).jpeg")
                cell.atmosphereImageView.image = UIImage(named:"newSliderCafe\(atmoRating[indexPath.row]).jpeg")
                cell.placePinButton.setBackgroundImage(UIImage(named: "cafePin.jpeg"), forState: UIControlState.Normal)
                
            }else if(placeType[indexPath.row] == "restaurant" || placeType[indexPath.row] == "meal_takeaway" || placeType[indexPath.row] == "street_adress" || placeType[indexPath.row] == "food" || placeType[indexPath.row] == "grocery_or_supermarket"){
                
                cell.foodImageView.image = UIImage(named:"newSliderFood\(foodRating[indexPath.row]).jpeg")
                cell.serviceImageView.image = UIImage(named:"newSliderFood\(serviceRating[indexPath.row]).jpeg")
                cell.atmosphereImageView.image = UIImage(named:"newSliderFood\(atmoRating[indexPath.row]).jpeg")
                cell.placePinButton.setBackgroundImage(UIImage(named: "foodPin.jpeg"), forState: UIControlState.Normal)
                
            }else if(placeType[indexPath.row] == "bar" || placeType[indexPath.row] == "night_club"){
                
                cell.foodImageView.image = UIImage(named:"newSliderDrinks\(foodRating[indexPath.row]).jpeg")
                cell.serviceImageView.image = UIImage(named:"newSliderDrinks\(serviceRating[indexPath.row]).jpeg")
                cell.atmosphereImageView.image = UIImage(named:"newSliderDrinks\(atmoRating[indexPath.row]).jpeg")
                cell.placePinButton.setBackgroundImage(UIImage(named: "drinksPin.jpeg"), forState: UIControlState.Normal)
                
            }else if(placeType[indexPath.row] == "entertainment"){
                
                cell.foodImageView.image = UIImage(named:"newSliderEvents\(foodRating[indexPath.row]).jpeg")
                cell.serviceImageView.image = UIImage(named:"newSliderEvents\(serviceRating[indexPath.row]).jpeg")
                cell.atmosphereImageView.image = UIImage(named:"newSliderEvents\(atmoRating[indexPath.row]).jpeg")
                cell.placePinButton.setBackgroundImage(UIImage(named: "eventsPin.jpeg"), forState: UIControlState.Normal)
                
            }else if(placeType[indexPath.row] == "store" || placeType[indexPath.row] == "home_goods_store" || placeType[indexPath.row] == "clothing_store" || placeType[indexPath.row] == "shoe_store"){
                
                cell.foodImageView.image = UIImage(named:"newSliderRetail\(foodRating[indexPath.row]).jpeg")
                cell.serviceImageView.image = UIImage(named:"newSliderRetail\(serviceRating[indexPath.row]).jpeg")
                cell.atmosphereImageView.image = UIImage(named:"newSliderRetail\(atmoRating[indexPath.row]).jpeg")
                cell.placePinButton.setBackgroundImage(UIImage(named: "retailPin.jpeg"), forState: UIControlState.Normal)
                
            }else{
                
                cell.foodImageView.image = UIImage(named:"newSliderEvents\(foodRating[indexPath.row]).jpeg")
                cell.serviceImageView.image = UIImage(named:"newSliderEvents\(serviceRating[indexPath.row]).jpeg")
                cell.atmosphereImageView.image = UIImage(named:"newSliderEvents\(atmoRating[indexPath.row]).jpeg")
                cell.placePinButton.setBackgroundImage(UIImage(named: "eventsPin.jpeg"), forState: UIControlState.Normal)
                
            }
            
            return cell
        }else if(state == "followers"){
            let cell = tableView.dequeueReusableCellWithIdentifier("friendBloggerTableViewCell", forIndexPath: indexPath) as! friendBloggerTableViewCell
            
            cell.userNameLabel.text = "\(firstName[indexPath.row]) \(lastName[indexPath.row])"
            cell.userMetricsLabel.text = ""
            cell.userProfileImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            cell.self.userProfileImage.layer.cornerRadius = cell.self.userProfileImage.layer.frame.width/2
            cell.self.userProfileImage.clipsToBounds = true
            /*
            cell.userNameLabel.text = glblUser.friends[indexPath.row].firstName + " " + glblUser.friends[indexPath.row].lastName
            cell.userProfileImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            cell.self.userProfileImage.layer.cornerRadius = cell.self.userProfileImage.layer.frame.width/2
            cell.self.userProfileImage.clipsToBounds = true
            */
            
            return cell
        }else if(state == "following"){
            let cell = tableView.dequeueReusableCellWithIdentifier("friendBloggerTableViewCell", forIndexPath: indexPath) as! friendBloggerTableViewCell
            
            cell.userNameLabel.text = "\(firstName[indexPath.row]) \(lastName[indexPath.row])"
            cell.userMetricsLabel.text = ""
            cell.userProfileImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            cell.self.userProfileImage.layer.cornerRadius = cell.self.userProfileImage.layer.frame.width/2
            cell.self.userProfileImage.clipsToBounds = true
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("genericCell", forIndexPath: indexPath)

            cell.textLabel?.text = "\(firstName[indexPath.row]) \(lastName[indexPath.row])"

            return cell
        }
    
    }
    

}
