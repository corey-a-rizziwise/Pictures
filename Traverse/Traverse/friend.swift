//
//  friend.swift
//  Traverse
//
//  Created by ahmed moussa on 10/10/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

/*
Overview of Funcitonality:

- Creating global class to store all the user's friends and their friend's places within the app

*/


//Import Foundation: class needed to initiate Foundation framework
import Foundation

//Class friend: Creates array for friends, counts places they have visited, 
// stores their name (first/last), email address, and unique ID

class friend{
    var places = [googlePlace]()
    var numOfPlaces = 0
    var firstName = "Ramen Crazy NYC"
    var lastName = "(Our 6 Favorite Spots)"
    var email = "nitch@gmail.com"
    var id = "123"
    var description = "Photographer. Explorer. Foody. Lover of a good drink and a great book. Follow me!"
    var isFriend = true
    
    var placesCount = 0
    var countFollowers = 0
    var countFollowing = 0
 
    //Store first/last names, email address, and unique ID
    init(){
        places.append(googlePlace(name: "ahmedPlace4", address: "ahmedPlace1", coordinate: CLLocationCoordinate2D(latitude: 33.428537, longitude: -111.944071), type: "bar", phoneNumber: "ahmedPlace", website: NSURL(), id: "ahmed, get the id"))
        places.append(googlePlace(name: "ahmedPlace3", address: "ahmedPlace2", coordinate: CLLocationCoordinate2D(latitude: 33.427768, longitude: -111.943198), type: "restaurant", phoneNumber: "ahmedPlace", website:  NSURL(), id: "ahmed, get the id"))
        places.append(googlePlace(name: "ahmedPlace2", address: "ahmedPlace3", coordinate: CLLocationCoordinate2D(latitude: 33.429692, longitude: -111.944513), type: "ahmedPlace", phoneNumber: "ahmedPlace", website:  NSURL(), id: "ahmed, get the id"))
        places.append(googlePlace(name: "ahmedPlace1", address: "ahmedPlace4", coordinate: CLLocationCoordinate2D(latitude: 33.429009, longitude: -111.942205), type: "ahmedPlace", phoneNumber: "ahmedPlace", website:
            NSURL(), id: "ahmed, get the id"))
    }
    
    //Every place created above now will have a firstName and lastName
    init(firstName: String, lastName: String){
        self.firstName = firstName
        self.lastName = lastName
        
        places.append(googlePlace(name: "ahmedPlace4", address: "ahmedPlace1", coordinate: CLLocationCoordinate2D(latitude: 33.428537, longitude: -111.944071), type: "bar", phoneNumber: "ahmedPlace", website:  NSURL(), id: "ahmed, get the id"))
        places.append(googlePlace(name: "ahmedPlace3", address: "ahmedPlace2", coordinate: CLLocationCoordinate2D(latitude: 33.427768, longitude: -111.943198), type: "restaurant", phoneNumber: "ahmedPlace", website:  NSURL(), id: "ahmed, get the id"))
        places.append(googlePlace(name: "ahmedPlace2", address: "ahmedPlace3", coordinate: CLLocationCoordinate2D(latitude: 33.429692, longitude: -111.944513), type: "ahmedPlace", phoneNumber: "ahmedPlace", website:  NSURL(), id: "ahmed, get the id"))

    }
    init(firstName: String, lastName: String, email: String, id: String, numberOfPlaces: Int, numberOfFollowers: Int, description: String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
        self.placesCount = numberOfPlaces
        self.countFollowers = numberOfFollowers
        self.description = description
        
    }

}