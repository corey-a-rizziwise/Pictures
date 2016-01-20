//
//  mainUser.swift
//  Traverse
//
//  Created by ahmed moussa on 10/11/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

/*
Overview of Funcitonality:

- Creates global class for new user
- Assigns array of friends to a user
- Assigns array of places to a user
- Allows user to view all traverse users
- Allows user to view all traverse bloggers
*/

//Import Foundation
//Class mainUser: See Above
import Foundation
class mainUser{
    var activity = [newsFeed]()
    
    var places = [googlePlace]()
    var friends = [friend]()
    var everyone = [friend]()
    var actualEveryone = [friend]()
    var bloggers = [blogger]()
    var friend1 = friend()
    var currentState = "mainMap"
    //var bloggerMap =
    var firstName = "TName"
    var lastName = "TLastName"
    var id = "ID"
    var neoID = "NewID"
    var description = "Photographer. Explorer. Foody. Lover of a good drink and a great book. Follow me!"
    var numOfPlaces = 0
    var email = "a"
    var pswd = "a"
    var numOfUsers = 0
    var loggedIn = false
    var loggedOut  = false
    var numOfFriends = 0
    var numOfBloggers = 0
    var friendName = ""
    var friendID = 0
    var friendEmail = ""
    var friendPlaces = 0
    var fromSignUp = 0
    var friendPlacesCount = 0
    var friendCountFollowers = 0
    var friendCountFollowing = 0
    var profileId = ""
    var profilePlacesCount = 0
    var profileFollowersCount = 0
    var profileFollowingCount = 0
    
    var userPlacesCount = 0
    var userCountFollowers = 0
    var userCountFollowing = 0
    
    var serverLink = "http://ec2-52-91-227-233.compute-1.amazonaws.com"
    var serverUse = "neo4j"
    var serverPass = "7ducksrw"
    
    // Sets default location within app. Used if user does not allow traverse to access location
    var homeLocation =  CLLocationCoordinate2DMake(40.7478468,-73.9872568)
    
    init(){
        
    }
    
    init(place: googlePlace){
        places.append(place)
    }
    init(firstName: String, lastName: String){
        self.firstName = firstName
        self.lastName = lastName
        
        let ratingTip = "This place has incredible noms and it is right off the back of Mill for some drinks afterwards"
        activity.append(newsFeed(raterName: "Ahmed Moussa", placeName: "Culinary Dropout", tip: ratingTip, time: "now1", date: "today!1", foodRating: 5, atmoRating: 5, servRating: 4, type: "Restaurant", placeLocation: "123 East Normal Street"))

    }
}
var glblUser = mainUser(firstName: "Ahmed", lastName: "Moussa")