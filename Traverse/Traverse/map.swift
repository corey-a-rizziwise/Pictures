//
//  map.swift
//  Traverse
//
//  Created by ahmed moussa on 11/4/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

/*
Overview of Funcitonality:

Sub class of classBlogger that we use to display TraverseTeam Maps (Pre-made maps)
- Gives the map a name
- Gives access to googlePlaces functionality
*/

import Foundation
class map{
    var places = [googlePlace]()
    var name = "mapName"
    var numOfPlaces = 0
    
    init(name: String){
        self.name = name
    }
}