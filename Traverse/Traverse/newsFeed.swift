//
//  newsFeed.swift
//  Traverse
//
//  Created by ahmed moussa on 12/14/15.
//  Copyright © 2015 Samuel Wang. All rights reserved.
//

import Foundation

class newsFeed{
    var raterName: String

    var tip: String
    
    var placeName: String
    var foodRating: Int
    var atmoRating: Int
    var servRating: Int
    var placeLocation: String
    var time: String
    var date: String
    var type : String
    
    init(raterName: String, placeName: String, tip: String, time: String, date: String, foodRating: Int, atmoRating: Int, servRating: Int, type: String, placeLocation: String){
        self.raterName = raterName
        self.placeName = placeName
        self.tip = tip
        self.foodRating = foodRating
        self.atmoRating = atmoRating
        self.servRating = servRating
        self.time = time
        self.date = date
        self.type = type
        self.placeLocation = placeLocation
    }
}