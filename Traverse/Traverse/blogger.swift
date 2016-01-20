//
//  blogger.swift
//  Traverse
//
//  Created by ahmed moussa on 11/4/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//


/*
Overview of Funcitonality:

- Creating global class to store and display bloggers within the app
*/

import Foundation

//Class blogger: Creates array for bloggers, counts places they have visited,
// stores their name (first/last), email address, and unique ID
class blogger{
    
    var maps = [map]()
    var places = [googlePlace]()
    var firstName = "sampleBloggerName"
    var lastName = "sampleBloggerLastName"
    var email = "blogger_person@gmail.com"
    var id = "123blgger"
    var numOfBCustomMaps = 0
    var numOfBCustomMapPlaces = 0
    var nickname = ""
    
    init(){
//        maps.append(map(name: "map1 sandwiches"))
//        maps.append(map(name: "map2 chinese"))
//        maps.append(map(name: "map3 american"))
//        maps.append(map(name: "map4 sushi"))
//        
//        places.append(googlePlace(name: "bloggerPlace4", address: "ahmedPlace1", coordinate: CLLocationCoordinate2D(latitude: 33.428537, longitude: -111.944071), type: "bar", phoneNumber: "ahmedPlace", website: NSURL(), id: "ahmed, get the id"))
//        places.append(googlePlace(name: "bloggerPlace3", address: "ahmedPlace2", coordinate: CLLocationCoordinate2D(latitude: 33.427768, longitude: -111.943198), type: "restaurant", phoneNumber: "ahmedPlace", website:  NSURL(), id: "ahmed, get the id"))
//        places.append(googlePlace(name: "bloggerPlace2", address: "ahmedPlace3", coordinate: CLLocationCoordinate2D(latitude: 33.429692, longitude: -111.944513), type: "ahmedPlace", phoneNumber: "ahmedPlace", website:  NSURL(), id: "ahmed, get the id"))
//        places.append(googlePlace(name: "bloggerPlace1", address: "ahmedPlace4", coordinate: CLLocationCoordinate2D(latitude: 33.429009, longitude: -111.942205), type: "ahmedPlace", phoneNumber: "ahmedPlace", website:  NSURL(), id: "ahmed, get the id"))
//        maps[0].places = places
//        maps[1].places = places
//        maps[2].places = places
//        maps[3].places = places
        
    }
    init(firstName: String, lastName: String){
        self.firstName = firstName
        self.lastName = lastName
        
    }
    init(firstName: String, lastName: String, email: String, id: String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.id = id
        
    }
    
}