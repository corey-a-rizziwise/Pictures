//
//  moreInfoViewController.swift
//  Traverse
//
//  Created by Corey Rizzi-Wise on 11/1/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

import UIKit

class moreInfoViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    //
    //more tips view controller
    //
    var firstName2 = [String]()
    var lastName2 = [String]()
    
    var placeName2 = [String]()
    var placeAddress2 = [String]()
    var placeType2 = [String]()
    
    var reviewDate2 = [String]()
    var reviewTime2 = [String]()
    var reviewText2 = [String]()
    var foodRating2 = [Int]()
    var serviceRating2 = [Int]()
    var atmoRating2 = [Int]()
    //
    //theo attributes needed
    //
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
    var nodeID = 0
    
    var descriptionString = "sample Place Description"
    var Place = googlePlace()
    var avgFood = 1
    var avgService = 1
    var avgAtmosphere = 1
    
    //
    //rate and review attritbutes
    //
    var foodRating = 1
    var serviceRating = 1
    var atmoRating = 1
    var userReviewText = "sampleReview"
    var userLongitude = 0.0
    var userLatitude = 0.0
    
    var rateState = false
    //
    //moreInfoView Top Section
    //
    
    @IBOutlet weak var goThereButton: UIButton!
    @IBOutlet weak var beenThereButton: UIButton!
    
    @IBOutlet weak var placeTypeImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //
    //moreInfoView Middle Section
    //
    
    @IBOutlet weak var atmosphereSlider: UIImageView!
    @IBOutlet weak var atmosphereLabel: UILabel!
    @IBOutlet weak var serviceSlider: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var foodSlider: UIImageView!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var topBar: UIImageView!
    @IBOutlet weak var foodImage1: UIImageView!
    @IBOutlet weak var foodImage2: UIImageView!
    @IBOutlet weak var foodImage3: UIImageView!
    @IBOutlet weak var moreImagesButton: UIButton!
    @IBOutlet weak var bottomBar: UIImageView!
    @IBOutlet weak var bottomBar1: UIImageView!
    
    //
    //moreInfoView Bottom Section
    //
    
    @IBOutlet var tipBox: UILabel!
    @IBOutlet var tipBox2: UILabel!
    @IBOutlet var tipBox3: UILabel!
    @IBOutlet var rater1: UILabel!
    @IBOutlet var rater3: UILabel!
    @IBOutlet var rater2: UILabel!
    @IBOutlet weak var seeMoreReviewsButton: UIButton!
    
    var imageView: UIImageView!

    //
    //rateButtons
    //
    @IBOutlet weak var foodMinusButton: UIButton!
    @IBOutlet weak var foodPlusButton: UIButton!
    @IBOutlet weak var serviceMinusButton: UIButton!
    @IBOutlet weak var servicePlusButton: UIButton!
    @IBOutlet weak var atmoMinusButton: UIButton!
    @IBOutlet weak var atmoPlusButton: UIButton!
    @IBOutlet weak var submitReview: UIButton!

    
    //
    //moreInfoView Submit Section
    //
    
    @IBOutlet weak var reviewText: UITextView!
    //
    //food stuff
    //
    @IBOutlet weak var FoodRateLabel: UILabel!
    
    @IBAction func FoodRatePlus(sender: UIButton) {
        if(foodRating < 5){
            foodRating++
            FoodRateLabel.text = "\(foodRating)"
        }
    }
    
    @IBAction func FoodRateMinus(sender: UIButton) {
        if(foodRating > 1){
            foodRating--
            FoodRateLabel.text = "\(foodRating)"
        }
    }
    //
    //service stuff
    //
    @IBOutlet weak var ServiceRateLabel: UILabel!
    //
    
    @IBAction func ServiceRatePlus(sender: UIButton) {
        if(serviceRating < 5){
            serviceRating++
            ServiceRateLabel.text = "\(serviceRating)"
        }
    }

    @IBAction func ServiceRateMinus(sender: AnyObject) {
        if(serviceRating > 1){
            serviceRating--
            ServiceRateLabel.text = "\(serviceRating)"
        }
    }
    //
    //atmosphere stuff
    //
    @IBOutlet weak var AtmoRateLabel: UILabel!
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
    //
    //review text stuff
    //
    @IBAction func saveReviewButton(sender: UIButton) {
        userReviewText = reviewText.text
        
        //if(id != neoID){
        //  CreatePlaceNode()
        //SaveData({() in
        //  })
        //}
        submitReview.enabled = false
        
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
    
    
    override func viewDidLoad() {
        reviewText.delegate = self
        //
        //Round the corners of foodImage1-3
        //
        /*
        self.mainUserProfilePicture.layer.cornerRadius = self.mainUserProfilePicture.frame.size.width/2
        self.mainUserProfilePicture.clipsToBounds = true
        */
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        foodImage1.layer.cornerRadius = foodImage1.frame.size.width/15
        foodImage1.clipsToBounds = true
        foodImage1.layer.borderWidth = 2
        foodImage2.layer.cornerRadius = foodImage2.frame.size.width/15
        foodImage2.clipsToBounds = true
        foodImage2.layer.borderWidth = 2
        foodImage3.layer.cornerRadius = foodImage3.frame.size.width/15
        foodImage3.clipsToBounds = true
        foodImage3.layer.borderWidth = 2
        submitReview.layer.cornerRadius = submitReview.frame.size.width/8
        submitReview.clipsToBounds = true
        
        
        //
        //Change colors based on the type of place that is clicked
        //
        if(Place.placeType == "cafe"){
            
            scrollView.backgroundColor = glblColor.cafeDarkColor
            nameLabel.textColor = glblColor.cafeDarkColor
            addressLabel.textColor = glblColor.cafeDarkColor
            descriptionLabel.textColor = glblColor.cafeDarkColor
            //
            //rate UI stuff
            //
            foodMinusButton.setBackgroundImage(UIImage(named: "minusButtonCafe.jpeg"), forState: UIControlState.Normal)
            foodPlusButton.setBackgroundImage(UIImage(named: "plusButtonCafe.jpeg"), forState: UIControlState.Normal)
            serviceMinusButton.setBackgroundImage(UIImage(named: "minusButtonCafe.jpeg"), forState: UIControlState.Normal)
            servicePlusButton.setBackgroundImage(UIImage(named: "plusButtonCafe.jpeg"), forState: UIControlState.Normal)
            atmoMinusButton.setBackgroundImage(UIImage(named: "minusButtonCafe.jpeg"), forState: UIControlState.Normal)
            atmoPlusButton.setBackgroundImage(UIImage(named: "plusButtonCafe.jpeg"), forState: UIControlState.Normal)
            submitReview.backgroundColor = glblColor.cafeDarkColor
            
            
            
            placeTypeImage.image = UIImage(named: "moreInfoCafeIcon.jpeg")
            atmosphereSlider.image = UIImage(named: "newSliderCafe\(Place.avgAtmosphere).jpeg")
            atmosphereLabel.textColor = glblColor.cafeDarkColor
            serviceSlider.image = UIImage(named: "newSliderCafe\(Place.avgService).jpeg")
            serviceLabel.textColor = glblColor.cafeDarkColor
            foodSlider.image = UIImage(named: "newSliderCafe\(Place.avgFood).jpeg")
            foodLabel.textColor = glblColor.cafeDarkColor
            
            topBar.image = UIImage(named: "moreInfoDividerCafe.jpeg")
            moreImagesButton.setBackgroundImage(UIImage(named: "moreInfoSwipeRightCafe.jpeg"), forState: UIControlState.Normal)
            foodImage1.layer.borderColor = glblColor.cafeDarkColor.CGColor
            foodImage2.layer.borderColor = glblColor.cafeDarkColor.CGColor
            foodImage3.layer.borderColor = glblColor.cafeDarkColor.CGColor
            //bottomBar.image = UIImage(named: "moreInfoDividerCafe.jpeg")
            bottomBar1.image = UIImage(named: "moreInfoDividerCafe.jpeg")
            
            tipBox.textColor = glblColor.cafeDarkColor
            tipBox2.textColor = glblColor.cafeDarkColor
            tipBox3.textColor = glblColor.cafeDarkColor
            rater1.textColor = glblColor.cafeDarkColor
            rater2.textColor = glblColor.cafeDarkColor
            rater3.textColor = glblColor.cafeDarkColor
            seeMoreReviewsButton.setTitleColor(glblColor.cafeDarkColor, forState: UIControlState.Normal)
        }else if(Place.placeType == "restaurant" || Place.placeType == "meal_takeaway" || Place.placeType == "street_address" || Place.placeType == "food" || Place.placeType == "grocery_or_supermarket"){

            
            scrollView.backgroundColor = glblColor.foodDarkColor
            nameLabel.textColor = glblColor.foodDarkColor
            addressLabel.textColor = glblColor.foodDarkColor
            descriptionLabel.textColor = glblColor.foodDarkColor
            //
            //rate UI stuff
            //
            foodMinusButton.setBackgroundImage(UIImage(named: "minusButtonFood.jpeg"), forState: UIControlState.Normal)
            foodPlusButton.setBackgroundImage(UIImage(named: "plusButtonFood.jpeg"), forState: UIControlState.Normal)
            serviceMinusButton.setBackgroundImage(UIImage(named: "minusButtonFood.jpeg"), forState: UIControlState.Normal)
            servicePlusButton.setBackgroundImage(UIImage(named: "plusButtonFood.jpeg"), forState: UIControlState.Normal)
            atmoMinusButton.setBackgroundImage(UIImage(named: "minusButtonFood.jpeg"), forState: UIControlState.Normal)
            atmoPlusButton.setBackgroundImage(UIImage(named: "plusButtonFood.jpeg"), forState: UIControlState.Normal)
            submitReview.backgroundColor = glblColor.foodDarkColor

            
            placeTypeImage.image = UIImage(named: "moreInfoFoodIcon.jpeg")
            atmosphereSlider.image = UIImage(named: "newSliderFood\(Place.avgAtmosphere).jpeg")
            atmosphereLabel.textColor = glblColor.foodDarkColor
            serviceSlider.image = UIImage(named: "newSliderFood\(Place.avgService).jpeg")
            serviceLabel.textColor = glblColor.foodDarkColor
            foodSlider.image = UIImage(named: "newSliderFood\(Place.avgFood).jpeg")
            foodLabel.textColor = glblColor.foodDarkColor
            
            topBar.image = UIImage(named: "moreInfoDividerFood.jpeg")
            moreImagesButton.setBackgroundImage(UIImage(named: "moreInfoSwipeRightFood.jpeg"), forState: UIControlState.Normal)
            foodImage1.layer.borderColor = glblColor.foodDarkColor.CGColor
            foodImage2.layer.borderColor = glblColor.foodDarkColor.CGColor
            foodImage3.layer.borderColor = glblColor.foodDarkColor.CGColor
            //bottomBar.image = UIImage(named: "moreInfoDividerFood.jpeg")
            bottomBar1.image = UIImage(named: "moreInfoDividerFood.jpeg")
            
            tipBox.textColor = glblColor.foodDarkColor
            tipBox2.textColor = glblColor.foodDarkColor
            tipBox3.textColor = glblColor.foodDarkColor
            rater1.textColor = glblColor.foodDarkColor
            rater2.textColor = glblColor.foodDarkColor
            rater3.textColor = glblColor.foodDarkColor
            seeMoreReviewsButton.setTitleColor(glblColor.foodDarkColor, forState: UIControlState.Normal)
        }else if(Place.placeType == "bar" || Place.placeType == "night_club"){

            
            scrollView.backgroundColor = glblColor.drinksDarkColor
            nameLabel.textColor = glblColor.drinksDarkColor
            addressLabel.textColor = glblColor.drinksDarkColor
            descriptionLabel.textColor = glblColor.drinksDarkColor
            //
            //rate UI stuff
            //
            foodMinusButton.setBackgroundImage(UIImage(named: "minusButtonDrinks.jpeg"), forState: UIControlState.Normal)
            foodPlusButton.setBackgroundImage(UIImage(named: "plusButtonDrinks.jpeg"), forState: UIControlState.Normal)
            serviceMinusButton.setBackgroundImage(UIImage(named: "minusButtonDrinks.jpeg"), forState: UIControlState.Normal)
            servicePlusButton.setBackgroundImage(UIImage(named: "plusButtonDrinks.jpeg"), forState: UIControlState.Normal)
            atmoMinusButton.setBackgroundImage(UIImage(named: "minusButtonDrinks.jpeg"), forState: UIControlState.Normal)
            atmoPlusButton.setBackgroundImage(UIImage(named: "plusButtonDrinks.jpeg"), forState: UIControlState.Normal)
            submitReview.backgroundColor = glblColor.drinksDarkColor

            
            placeTypeImage.image = UIImage(named: "moreInfoDrinksIcon.jpeg")
            atmosphereSlider.image = UIImage(named: "newSliderDrinks\(Place.avgAtmosphere).jpeg")
            atmosphereLabel.textColor = glblColor.drinksDarkColor
            serviceSlider.image = UIImage(named: "newSliderDrinks\(Place.avgService).jpeg")
            serviceLabel.textColor = glblColor.drinksDarkColor
            foodSlider.image = UIImage(named: "newSliderDrinks\(Place.avgFood).jpeg")
            foodLabel.textColor = glblColor.drinksDarkColor
            
            topBar.image = UIImage(named: "moreInfoDividerDrinks.jpeg")
            moreImagesButton.setBackgroundImage(UIImage(named: "moreInfoSwipeRightDrinks.jpeg"), forState: UIControlState.Normal)
            foodImage1.layer.borderColor = glblColor.drinksDarkColor.CGColor
            foodImage2.layer.borderColor = glblColor.drinksDarkColor.CGColor
            foodImage3.layer.borderColor = glblColor.drinksDarkColor.CGColor
            //bottomBar.image = UIImage(named: "moreInfoDividerDrinks.jpeg")
            bottomBar1.image = UIImage(named: "moreInfoDividerDrinks.jpeg")
            
            tipBox.textColor = glblColor.drinksDarkColor
            tipBox2.textColor = glblColor.drinksDarkColor
            tipBox3.textColor = glblColor.drinksDarkColor
            rater1.textColor = glblColor.drinksDarkColor
            rater2.textColor = glblColor.drinksDarkColor
            rater3.textColor = glblColor.drinksDarkColor
            seeMoreReviewsButton.setTitleColor(glblColor.drinksDarkColor, forState: UIControlState.Normal)
        }else if(Place.placeType == "entertainment"){

            
            scrollView.backgroundColor = glblColor.eventsDarkColor
            nameLabel.textColor = glblColor.eventsDarkColor
            addressLabel.textColor = glblColor.eventsDarkColor
            descriptionLabel.textColor = glblColor.eventsDarkColor
            //
            //rate UI stuff
            //
            foodMinusButton.setBackgroundImage(UIImage(named: "minusButtonEvents.jpeg"), forState: UIControlState.Normal)
            foodPlusButton.setBackgroundImage(UIImage(named: "plusButtonEvents.jpeg"), forState: UIControlState.Normal)
            serviceMinusButton.setBackgroundImage(UIImage(named: "minusButtonEvents.jpeg"), forState: UIControlState.Normal)
            servicePlusButton.setBackgroundImage(UIImage(named: "plusButtonEvents.jpeg"), forState: UIControlState.Normal)
            atmoMinusButton.setBackgroundImage(UIImage(named: "minusButtonEvents.jpeg"), forState: UIControlState.Normal)
            atmoPlusButton.setBackgroundImage(UIImage(named: "plusButtonEvents.jpeg"), forState: UIControlState.Normal)
            submitReview.backgroundColor = glblColor.eventsDarkColor

            
            
            placeTypeImage.image = UIImage(named: "moreInfoEventsIcon.jpeg")
            atmosphereSlider.image = UIImage(named: "newSliderEvents\(Place.avgAtmosphere).jpeg")
            atmosphereLabel.textColor = glblColor.eventsDarkColor
            serviceSlider.image = UIImage(named: "newSliderEvents\(Place.avgService).jpeg")
            serviceLabel.textColor = glblColor.eventsDarkColor
            foodSlider.image = UIImage(named: "newSliderEvents\(Place.avgFood).jpeg")
            foodLabel.textColor = glblColor.eventsDarkColor
            
            //topBar.image = UIImage(named: "moreInfoDividerEvents.jpeg")
            moreImagesButton.setBackgroundImage(UIImage(named: "moreInfoSwipeRightEvents.jpeg"), forState: UIControlState.Normal)
            foodImage1.layer.borderColor = glblColor.eventsDarkColor.CGColor
            foodImage2.layer.borderColor = glblColor.eventsDarkColor.CGColor
            foodImage3.layer.borderColor = glblColor.eventsDarkColor.CGColor
            //bottomBar.image = UIImage(named: "moreInfoDividerEvents.jpeg")
            bottomBar1.image = UIImage(named: "moreInfoDividerEvents.jpeg")
            
            tipBox.textColor = glblColor.eventsDarkColor
            tipBox2.textColor = glblColor.eventsDarkColor
            tipBox3.textColor = glblColor.eventsDarkColor
            rater1.textColor = glblColor.eventsDarkColor
            rater2.textColor = glblColor.eventsDarkColor
            rater3.textColor = glblColor.eventsDarkColor
            seeMoreReviewsButton.setTitleColor(glblColor.eventsDarkColor, forState: UIControlState.Normal)
        }else if(Place.placeType == "store" || Place.placeType == "home_goods_store" || Place.placeType == "department_store" || Place.placeType == "clothing_store" || Place.placeType == "shoe_store"){

            
            scrollView.backgroundColor = glblColor.retailDarkColor
            nameLabel.textColor = glblColor.retailDarkColor
            addressLabel.textColor = glblColor.retailDarkColor
            descriptionLabel.textColor = glblColor.retailDarkColor
            //
            //rate UI stuff
            //
            foodMinusButton.setBackgroundImage(UIImage(named: "minusButtonRetail.jpeg"), forState: UIControlState.Normal)
            foodPlusButton.setBackgroundImage(UIImage(named: "plusButtonRetail.jpeg"), forState: UIControlState.Normal)
            serviceMinusButton.setBackgroundImage(UIImage(named: "minusButtonRetail.jpeg"), forState: UIControlState.Normal)
            servicePlusButton.setBackgroundImage(UIImage(named: "plusButtonRetail.jpeg"), forState: UIControlState.Normal)
            atmoMinusButton.setBackgroundImage(UIImage(named: "minusButtonRetail.jpeg"), forState: UIControlState.Normal)
            atmoPlusButton.setBackgroundImage(UIImage(named: "plusButtonRetail.jpeg"), forState: UIControlState.Normal)
            submitReview.backgroundColor = glblColor.retailDarkColor

            
            placeTypeImage.image = UIImage(named: "moreInfoRetailIcon.jpeg")
            atmosphereSlider.image = UIImage(named: "newSliderRetail\(Place.avgAtmosphere).jpeg")
            atmosphereLabel.textColor = glblColor.retailDarkColor
            serviceSlider.image = UIImage(named: "newSliderRetail\(Place.avgService).jpeg")
            serviceLabel.textColor = glblColor.retailDarkColor
            foodSlider.image = UIImage(named: "newSliderRetail\(Place.avgFood).jpeg")
            foodLabel.textColor = glblColor.retailDarkColor
            
            topBar.image = UIImage(named: "moreInfoDividerRetail.jpeg")
            moreImagesButton.setBackgroundImage(UIImage(named: "moreInfoSwipeRightRetail.jpeg"), forState: UIControlState.Normal)
            foodImage1.layer.borderColor = glblColor.retailDarkColor.CGColor
            foodImage2.layer.borderColor = glblColor.retailDarkColor.CGColor
            foodImage3.layer.borderColor = glblColor.retailDarkColor.CGColor
            //bottomBar.image = UIImage(named: "moreInfoDividerRetail.jpeg")
            bottomBar1.image = UIImage(named: "moreInfoDividerRetail.jpeg")
            
            tipBox.textColor = glblColor.retailDarkColor
            tipBox2.textColor = glblColor.retailDarkColor
            tipBox3.textColor = glblColor.retailDarkColor
            rater1.textColor = glblColor.retailDarkColor
            rater2.textColor = glblColor.retailDarkColor
            rater3.textColor = glblColor.retailDarkColor
            seeMoreReviewsButton.setTitleColor(glblColor.retailDarkColor, forState: UIControlState.Normal)
        }else{

            
            scrollView.backgroundColor = glblColor.eventsDarkColor
            nameLabel.textColor = glblColor.eventsDarkColor
            addressLabel.textColor = glblColor.eventsDarkColor
            descriptionLabel.textColor = glblColor.eventsDarkColor
            //
            //rate UI stuff
            //
            foodMinusButton.setBackgroundImage(UIImage(named: "minusButtonEvents.jpeg"), forState: UIControlState.Normal)
            foodPlusButton.setBackgroundImage(UIImage(named: "plusButtonEvents.jpeg"), forState: UIControlState.Normal)
            serviceMinusButton.setBackgroundImage(UIImage(named: "minusButtonEvents.jpeg"), forState: UIControlState.Normal)
            servicePlusButton.setBackgroundImage(UIImage(named: "plusButtonEvents.jpeg"), forState: UIControlState.Normal)
            atmoMinusButton.setBackgroundImage(UIImage(named: "minusButtonEvents.jpeg"), forState: UIControlState.Normal)
            atmoPlusButton.setBackgroundImage(UIImage(named: "plusButtonEvents.jpeg"), forState: UIControlState.Normal)
            submitReview.backgroundColor = glblColor.eventsDarkColor

            
            
            placeTypeImage.image = UIImage(named: "moreInfoEventsIcon.jpeg")
            atmosphereSlider.image = UIImage(named: "newSliderEvents\(Place.avgAtmosphere).jpeg")
            atmosphereLabel.textColor = glblColor.eventsDarkColor
            serviceSlider.image = UIImage(named: "newSliderEvents\(Place.avgService).jpeg")
            serviceLabel.textColor = glblColor.eventsDarkColor
            foodSlider.image = UIImage(named: "newSliderEvents\(Place.avgFood).jpeg")
            foodLabel.textColor = glblColor.eventsDarkColor
            
            topBar.image = UIImage(named: "moreInfoDividerEvents.jpeg")
            moreImagesButton.setBackgroundImage(UIImage(named: "moreInfoSwipeRightEvents.jpeg"), forState: UIControlState.Normal)
            foodImage1.layer.borderColor = glblColor.eventsDarkColor.CGColor
            foodImage2.layer.borderColor = glblColor.eventsDarkColor.CGColor
            foodImage3.layer.borderColor = glblColor.eventsDarkColor.CGColor
            //bottomBar.image = UIImage(named: "moreInfoDividerEvents.jpeg")
            bottomBar1.image = UIImage(named: "moreInfoDividerEvents.jpeg")
            
            tipBox.textColor = glblColor.eventsDarkColor
            tipBox2.textColor = glblColor.eventsDarkColor
            tipBox3.textColor = glblColor.eventsDarkColor
            rater1.textColor = glblColor.eventsDarkColor
            rater2.textColor = glblColor.eventsDarkColor
            rater3.textColor = glblColor.eventsDarkColor
            seeMoreReviewsButton.setTitleColor(glblColor.eventsDarkColor, forState: UIControlState.Normal)
        }

        super.viewDidLoad()
        
        nameLabel.text = Place.name
        addressLabel.text = Place.address
        //descriptionString = Place.placeType
        //need to find a way to get a place's description
        descriptionLabel.text = Place.phoneNumber

        if(Place.tips[0] != ""){
            tipBox.text = Place.tips[0]
            rater1.text = "@\(Place.tipMakers[0])"
        }
        else if(Place.tips.count == 2){
            if(Place.tips[0] != ""){
                tipBox.text = Place.tips[0]
                rater1.text = "@\(Place.tipMakers[0])"
            }
            if(Place.tips[1] != ""){
                tipBox2.text = Place.tips[1]
                rater2.text = "@\(Place.tipMakers[1])"
            }
        }
        else if(Place.tips.count > 2){
            if(Place.tips[0] != ""){
                tipBox.text = Place.tips[0]
                rater1.text = "@\(Place.tipMakers[0])"
            }
            if(Place.tips[1] != ""){
                tipBox2.text = Place.tips[1]
                rater2.text = "@\(Place.tipMakers[1])"
            }
            if(Place.tips[2] != ""){
                tipBox3.text = Place.tips[2]
                rater3.text = "@\(Place.tipMakers[2])"
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    func textViewDidBeginEditing(textView: UITextView) {
        print("more info tip text did start editing")
        scrollView.setContentOffset(CGPoint(x: 0, y: 900), animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        if(rateState){
            scrollView.setContentOffset(CGPointMake(0, 750), animated: true)
            rateState = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toRatePlace"){
            let destVC = segue.destinationViewController as! rateViewController
            destVC.Place = self.Place
        }
        if(segue.identifier == "toMoreTips"){
            let destVC = segue.destinationViewController as! moreTipsTableViewController
            destVC.Place = self.Place
            destVC.firstName = firstName2 //probably don't need this because of tip makers
            destVC.lastName = lastName2 //probably don't need this because of tip makers
            destVC.placeName = placeName2 //probably don't need this?
            destVC.placeAddress = placeAddress2 //probabbly don't need this?
            destVC.placeType = placeType2
            destVC.reviewDate = reviewDate2
            destVC.reviewTime = reviewTime2
            destVC.reviewText = reviewText2
            destVC.foodRating = foodRating2
            destVC.serviceRating = serviceRating2
            destVC.atmoRating = atmoRating2
            print("THIS IS THE PLACE NAME \(placeName2)")
            print("THIS IS THE FIRST NAME \(firstName2)")
            
            /*
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
            */
        }
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
            relationship.setProp("ReviewText", propertyValue: "\(self.reviewText.text)")
            relationship.setProp("Date", propertyValue: "\(dateFormatter.stringFromDate(date))")
            relationship.setProp("Time", propertyValue: "\(timeFormatter.stringFromDate(date))")
            //
            //----------pass the longitude and latitiude to this view controller
            //
            //print("Review user longitude: \(self.userLongitude)")
            //print("Review user latitude: \(self.userLatitude)")
            relationship.setProp("Longitude", propertyValue: self.userLongitude)
            relationship.setProp("Latitude", propertyValue: self.userLatitude)
            
            theo.createRelationship(relationship, completionBlock: {(rel, error) in
                self.setHasReviewsTrue()
                
                for temp in glblUser.places{
                    if(temp.name == self.name){
                        print("\(temp.name)")
                        
                    }
                }

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
            self.foodRating = 1
            self.serviceRating = 1
            self.atmoRating = 1
            self.submitReview.titleLabel!.text = "Tip Added!"
            self.submitReview.titleLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
            self.submitReview.titleLabel!.numberOfLines = 2
            //
            //broken segue that does not exist anymore...?
            //
            self.performSegueWithIdentifier("toMainMap", sender: self)
            //print(cypher!.data[0]["averageFood"]!)
        })
    }
    
    
    //set height and width of scroll view
    /*
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSizeMake(view.frame.width, 2600)
    }
    */
    /*
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
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
