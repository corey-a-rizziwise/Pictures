//
//  bloggersTableViewController.swift
//  Traverse
//
//  Created by ahmed moussa on 11/4/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//


import UIKit

class BloggersTableViewController: UITableViewController {
    
    var state = "blogger"//"segmentedControlPlaces"//
    var currentBlogger = blogger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Traverse Maps"
        self.navigationController?.navigationBar.tintColor = glblColor.activeBlue
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return 1
        }
        else if(section == 1){
            return glblUser.bloggers[0].maps.count 
        }
        else{
            return 1
        }
       
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath)
            cell.backgroundColor = glblColor.traverseGray
            cell.textLabel?.text = "Click to Search for Bloggers"
            cell.textLabel?.textColor = glblColor.activeBlue
            cell.textLabel?.backgroundColor = glblColor.traverseGray
            
            return cell
        }
        else if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("bloggerCell", forIndexPath: indexPath)
            cell.textLabel?.text = glblUser.bloggers[0].maps[indexPath.row].name//"segmented Control cell \(indexPath.row)"
            
            return cell
        }
            //
            //Ahmed help lots ;-)
            //
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("bloggerCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Traverse Holiday Map"
            
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            return 50
        }
        else{
            return 40
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
        if(segue.identifier == "toBloggerMapPlaces"){
            
            let destVC = segue.destinationViewController as! mapViewController
            
            destVC.currentState = "followMap"
            destVC.currentBlogger = glblUser.bloggers[0]
            destVC.currentBloggerMapNo = indexPath.row
            glblUser.currentState = "followMap"
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 1){
            RetrieveCustomMap(indexPath.row, mapName: glblUser.bloggers[0].maps[indexPath.row].name)
        }
        
    }
    func RetrieveCustomMap(i: Int, mapName: String){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:Blogger)-[b:REVIEW]-(c:Place) where b.CustomMap = '\(mapName)' return c.Name, c.Latitude, c.Longitude, c.Address, c.Type, c.ID, round(avg(b.Food)), round(avg(b.Service)), round(avg(b.Atmosphere))"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            
            //print(glblUser.bloggers[0].maps[1].numOfPlaces)
            print("-------- \n \(cypher)")
            //while(mapCount < glblUser.bloggers[0].maps.count){
                var placesCount = 0
                while(placesCount < glblUser.bloggers[0].maps[i].numOfPlaces){
                    let name = cypher!.data[placesCount]["c.Name"]! as! String
                    let latitude = cypher!.data[placesCount]["c.Latitude"] as! Double
                    let longitude = cypher!.data[placesCount]["c.Longitude"] as! Double
                    let address = cypher!.data[placesCount]["c.Address"] as! String
                    let type = cypher!.data[placesCount]["c.Type"] as! String
                    let ID = cypher!.data[placesCount]["c.ID"] as! String
                    let avgFood = cypher!.data[placesCount]["round(avg(b.Food))"]! as! Int
                    let avgService = cypher!.data[placesCount]["round(avg(b.Service))"]! as! Int
                    let avgAtmosphere = cypher!.data[placesCount]["round(avg(b.Atmosphere))"]! as! Int
                    
                    glblUser.bloggers[0].maps[i].places.append(googlePlace(name: name, address: address, coordinate: CLLocationCoordinate2DMake(latitude, longitude), type: type, phoneNumber: "", website: NSURL(), id: ID, avgFood: avgFood, avgService: avgService, avgAtmosphere: avgAtmosphere))
                    //map1.places.append(googlePlace(name: name, address: address, coordinate: CLLocationCoordinate2DMake(latitude, longitude), type: type, phoneNumber: "", website: NSURL(), id: ID, avgFood: avgFood, avgService: avgService, avgAtmosphere: avgAtmosphere))
                    
                    placesCount++
                }
                //mapCount++}
            self.performSegueWithIdentifier("toBloggerMapPlaces", sender: self)
        })
    }
}
