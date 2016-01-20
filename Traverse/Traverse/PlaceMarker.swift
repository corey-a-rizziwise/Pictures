//
//  PlaceMarker.swift
//  GooglePlacesTrial
//
//  Created by ahmed moussa on 10/3/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

/*
Overview of Funcitonality:

- Utlizes PlaceMarker to assign custom markers to locations
*/

import GoogleMaps

//Class placeMarker: Get, return, and customize places using Google's GSMarker API
class PlaceMarker: GMSMarker {
    let place: googlePlace
    
    init(place: googlePlace){
        self.place = place
        super.init()

        position = place.coordinate
        //icon = UIImage(named: (place.types[0] as! String)+"_pin")
        if(place.placeType == "cafe"){
            icon = UIImage(named: "cafePin.jpg")
        }else if(place.placeType == "restaurant" || place.placeType == "meal_takeaway" || place.placeType == "street_address" || place.placeType == "food" || place.placeType == "grocery_or_supermarket"){
            icon = UIImage(named: "foodPin.jpg")
        }else if(place.placeType == "bar" || place.placeType == "night_club"){
            icon = UIImage(named: "drinksPin.jpg")
        }else if(place.placeType == "entertainment"){
            icon = UIImage(named: "eventsPin.jpg")
        }else if(place.placeType == "store" || place.placeType == "home_goods_store" || place.placeType == "department_store" || place.placeType == "clothing_store" || place.placeType == "shoe_store"){
            icon = UIImage(named: "retailPin.jpg")
        }else{
            icon = UIImage(named: "eventsPin.jpg")
        }
        groundAnchor = CGPoint(x: 0.5, y: 1)
        //appearAnimation = kGMSMarkerAnimationPop
        
        
        
    }
}
