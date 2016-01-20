//
//  moreTipsTableViewController.swift
//  Traverse
//
//  Created by ahmed moussa on 11/6/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

import UIKit

class moreTipsTableViewController: UITableViewController {
    
    var Place = googlePlace()
    
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
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Place.tips.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /*
        let cell = tableView.dequeueReusableCellWithIdentifier("tipCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = Place.tips[indexPath.row]
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return cell
        */
        let cellHeight = view.frame.height
        let cellWidth = view.frame.width
        let cell = tableView.dequeueReusableCellWithIdentifier("newsfeedCell", forIndexPath: indexPath) as! newsfeedTableViewCell
        /*
        self.mainUserProfilePicture.layer.cornerRadius = self.mainUserProfilePicture.frame.size.width/2
        self.mainUserProfilePicture.clipsToBounds = true
        */
        
        //code actually needed
        cell.userNameButton.setTitle(Place.tipMakers[indexPath.row], forState: UIControlState.Normal)
        cell.placeNameButton.setTitle(Place.tipPlaceName[indexPath.row], forState: UIControlState.Normal)
        cell.placeLocationLabel.text = Place.tipPlaceAddress[indexPath.row]
        cell.reviewTimeLabel.text = "\(Place.tipReviewDate[indexPath.row]) \(Place.tipReviewTime[indexPath.row])"//NEED TO EVENTUALLY GET THIS
        cell.placeReviewLabel.text = Place.tips[indexPath.row]//"This place has incredible noms and it is right off the back of Mill for some drinks afterwards"
        
        if(Place.placeType == "cafe"){
            
            cell.foodImageView.image = UIImage(named:"newSliderCafe\(Place.tipFoodRating[indexPath.row]).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderCafe\(Place.tipServiceRating[indexPath.row]).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderCafe\(Place.tipAtmoRating[indexPath.row]).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "cafePin.jpeg"), forState: UIControlState.Normal)
            
        }else if(Place.placeType == "restaurant" || Place.placeType == "meal_takeaway" || Place.placeType == "street_adress" || Place.placeType == "food" || Place.placeType == "grocery_or_supermarket"){
            
            cell.foodImageView.image = UIImage(named:"newSliderFood\(Place.tipFoodRating[indexPath.row]).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderFood\(Place.tipServiceRating[indexPath.row]).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderFood\(Place.tipAtmoRating[indexPath.row]).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "foodPin.jpeg"), forState: UIControlState.Normal)
            
        }else if(Place.placeType == "bar" || Place.placeType == "night_club"){
            
            cell.foodImageView.image = UIImage(named:"newSliderDrinks\(Place.tipFoodRating[indexPath.row]).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderDrinks\(Place.tipServiceRating[indexPath.row]).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderDrinks\(Place.tipAtmoRating[indexPath.row]).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "drinksPin.jpeg"), forState: UIControlState.Normal)
            
        }else if(Place.placeType == "entertainment"){
            
            cell.foodImageView.image = UIImage(named:"newSliderEvents\(Place.tipFoodRating[indexPath.row]).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderEvents\(Place.tipServiceRating[indexPath.row]).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderEvents\(Place.tipAtmoRating[indexPath.row]).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "eventsPin.jpeg"), forState: UIControlState.Normal)
            
        }else if(Place.placeType == "store" || Place.placeType == "home_goods_store" || Place.placeType == "clothing_store" || Place.placeType == "shoe_store"){
            
            cell.foodImageView.image = UIImage(named:"newSliderRetail\(Place.tipFoodRating[indexPath.row]).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderRetail\(Place.tipServiceRating[indexPath.row]).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderRetail\(Place.tipAtmoRating[indexPath.row]).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "retailPin.jpeg"), forState: UIControlState.Normal)
            
        }else{
            
            cell.foodImageView.image = UIImage(named:"newSliderEvents\(Place.tipAtmoRating[indexPath.row]).jpeg")
            cell.serviceImageView.image = UIImage(named:"newSliderEvents\(Place.tipServiceRating[indexPath.row]).jpeg")
            cell.atmosphereImageView.image = UIImage(named:"newSliderEvents\(Place.tipAtmoRating[indexPath.row]).jpeg")
            cell.placePinButton.setBackgroundImage(UIImage(named: "eventsPin.jpeg"), forState: UIControlState.Normal)
            
        }
        
        return cell
    }



    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            //return 150
            return view.frame.height/3
        }
        else{
            //return 120
            return view.frame.height/3
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "backToMoreInfo"){
            let destVC = segue.destinationViewController as! moreInfoViewController
            destVC.Place = self.Place
        }
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
}
