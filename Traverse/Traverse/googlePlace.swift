//
//  googlePlace.swift
//  Traverse
//
//  Created by ahmed moussa on 10/6/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//
/*
Overview of Funcitonality:

- Get access to user location and display on google maps
- Get access to data on places
- Assign tips to user's saved locations
*/






//how to proerly interact with NSURLs
/*
func textView(textView: UITextView, shouldInteractWithURL URL: NSURL,
inRange characterRange: NSRange) -> Bool {
// Make links clickable.
return true
}
*/

//Import CoreLocation: Get access to user location and display on google maps
import Foundation
import UIKit
import CoreLocation

class googlePlace {
    
    var name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let placeType: String
    //let placeDescription: String
    let phoneNumber: String
    let website: NSURL
    let id: String
    var tips = [String]()
    var tipMakers = [String]()
    var tipPlaceName = [String]()
    var tipPlaceAddress = [String]()
    var tipPlaceType = [String]()
    var tipReviewDate = [String]()
    var tipReviewTime = [String]()
    var tipFoodRating = [Int]()
    var tipServiceRating = [Int]()
    var tipAtmoRating = [Int]()

    var avgFood = 1
    var avgService = 1
    var avgAtmosphere = 1
    var numOfReviews = 0
    var firstName = 0
    var lastName = 0
    var reviews = ""
    
    init()
    {
        self.name = "sampleName"
        self.address = "sampleAddress"
        self.coordinate = CLLocationCoordinate2D()
        self.placeType = "sampleType"
        //self.placeDescription = "sampleDescription"
        self.phoneNumber = "samplePhoneNumber"
        self.id = "sampleID"
        self.website = NSURL()//string: "www.smd.com")
        
        self.tips.append("Tip: Yummy food and great atmosphere!")
        self.tips.append("Tip: Service was great and dessert was awesome.")
        self.tips.append("Tip: Don't forget to check out the appetizers, they go well with the sauces!")
        
        
        self.tipPlaceName.append("Place Name")
        self.tipPlaceAddress.append("Place Address")
        self.tipPlaceType.append("Food")
        self.tipReviewDate.append("1/1/16")
        self.tipReviewTime.append("11:11 PM")
        self.tipFoodRating.append(5)
        self.tipServiceRating.append(5)
        self.tipAtmoRating.append(5)
        
        self.tipMakers.append("@Ahmed M")
        self.tipMakers.append("@Corey RW")
        self.tipMakers.append("@Colby W")

    }
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, type: String, phoneNumber: String, website: NSURL, id: String)
    {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.placeType = type
        //self.placeDescription = attribute_set
        self.phoneNumber = phoneNumber
        self.website = website
        self.id = id
        
        //self.tips.append("Tip: Yummy food and great atmosphere!")
        //self.tips.append("Tip: Service was great and dessert was awesome.")
        //self.tips.append("Tip: Don't forget to check out the appetizers, they go well with the sauces!")
        
        
        //self.tipMakers.append("@Ahmed M")
        //self.tipMakers.append("@Corey RW")
        //self.tipMakers.append("@Colby W")
    }
    init(name: String, address: String, coordinate: CLLocationCoordinate2D, type: String, phoneNumber: String, website: NSURL, id: String, avgFood: Int, avgService: Int, avgAtmosphere: Int)
    {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.placeType = type
        //self.placeDescription = attribute_set
        self.phoneNumber = phoneNumber
        self.website = website
        self.id = id
        self.avgAtmosphere = avgAtmosphere
        self.avgFood = avgFood
        self.avgService = avgService
    }

    

    
}