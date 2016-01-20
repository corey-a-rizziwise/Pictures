//
//  mapViewController.swift
//
//  Created by Samuel Wang on 9/29/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//
//Overview of funcitonality
/*
Everything having to do with displaying, using, and transfering data to and from the map
*/
//
import UIKit
import GoogleMaps


class mapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, LocateOnTheMap, UISearchBarDelegate  {
    //var user = mainUser(firstName: "corey", lastName: "RW")
    
    // ------------------------------------ Search bar stuff
    var searchResultController: searchTableViewController!
    var resultsArray = [String]()
    // ------------------------------------ Search bar stuff
    //rate scroll boolean
    var rateButtonClicked = false
    //rate scroll boolean
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var center = CLLocationCoordinate2DMake(33.428537, -111.944071)//33.4294° N, 111.9431° W
    
    var placesClient: GMSPlacesClient?
    var placePicker: GMSPlacePicker?
    
    var placeName = "placeName"
    var placeAddress = "place.formattedAddress"
    var placePhone = "placePhone"
    var placeType = "placeType" as String
    var placeCoordinate = CLLocationCoordinate2D()
    var placeLatitude = 0.00 as Double
    var placeLongitude = 0.00 as Double
    var placeWebsite = NSURL()
    var placeID = "sampleID"
    var places = [googlePlace]()
    var place1 = googlePlace()
    var numOfReviews = 0
    
    var currentState = "mainMap"//"friendMap"
    var currentBlogger = blogger()
    var currentBloggerMapNo = 0
    var friend1 = friend()
    
    var infoViewBottomButton = UIButton()
    var infoViewRateButton = UIButton(type: UIButtonType.System)
    var infoViewGoThereButton = UIButton()
    var infoSemiCircle = UIImageView()
    var infoType = UIImageView()
    var foodSlider = UIImageView()
    var serviceSlider = UIImageView()
    var atmoSlider = UIImageView()
    
    
    
    @IBOutlet var mapView: GMSMapView!
    
    //
    //What camera position does this change?
    //Changes the zoom when a friend button is clicked on
    //
    var camera = GMSCameraPosition.cameraWithTarget(glblUser.homeLocation, zoom: 13)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        
        //UINavigationBar.appearance().barTintColor = glblColor.drinksDarkColor
        UINavigationBar.appearance().barTintColor = glblColor.traverseGray
        
        let navView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        navView.contentMode = .ScaleAspectFit
        navView.layer.cornerRadius = navView.frame.size.width/2
        navView.clipsToBounds = true
        let navImage = UIImage(named: "Traverse2.jpg")
        navView.image = navImage
        navigationItem.titleView = navView
        
        //--------------make this hamburger button work @Ahmed/Sam what segue do we need to get the action back?
        /*
        let threeLinesImage = UIImage(named: "threeLines.jpg")
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0, width: navigationController!.navigationBar.frame.width/10, height: navigationController!.navigationBar.frame.height/1.5))
        button.setBackgroundImage(threeLinesImage, forState: .Normal)
        button.addTarget(self, action: Selector("openInfo"), forControlEvents: UIControlEvents.TouchUpInside)
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        */
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        if(glblUser.loggedIn == false){
            performSegueWithIdentifier("toLogin", sender: self)
        }
        
        TabButton.target = self.revealViewController()
        TabButton.action = Selector("revealToggle:")
        TabButton.setBackgroundImage(UIImage(named: "threeLines.jpg"), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //
        //Camera position change?
        //
        //
        let camera = GMSCameraPosition.cameraWithLatitude (33.428537, longitude: -111.944071, zoom: 1)
        //var camera = GMSCameraPosition.cameraWithLatitude (location.coordinate.latitude, longitude: location.cordinate.longitude, zoom: 15)
        //mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.myLocationEnabled = true
        self.view = mapView
        
        
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.camera = self.camera
        mapView.settings.myLocationButton = true
        mapView.myLocationEnabled = true
        //let mapInsets = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0)
        let mapInsets = UIEdgeInsetsMake(0.0, 0.0, screenHeight/14, 0.0)
        mapView.padding = mapInsets
        self.view = mapView
        
        
        if(currentState == "mainMap"){
            for temp: googlePlace in glblUser.places{
                let marker = PlaceMarker(place: temp)
                marker.map = mapView
            }
        }
        else if(currentState == "friendMap"){
            for temp: googlePlace in friend1.places{
                let marker = PlaceMarker(place: temp)
                marker.map = mapView
            }
        }
        else if(currentState == "followMap"){
            print("currentBloggerMapNo \(currentBloggerMapNo)")
            for temp: googlePlace in currentBlogger.maps[currentBloggerMapNo].places{
                let marker = PlaceMarker(place: temp)
                marker.map = mapView
            }
        }
        else if(currentState == "myMap" ){
            for temp: googlePlace in friend1.places{
                let marker = PlaceMarker(place: temp)
                marker.map = mapView
            }
        }
        else if(currentState == "potentialFriendMap" ){
            for temp: googlePlace in friend1.places{
                let marker = PlaceMarker(place: temp)
                marker.map = mapView
            }
        }
        
    }
    
    // ------------------------------------ Search bar stuff begins
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        searchResultController = searchTableViewController()
        searchResultController.delegate = self
    }
    
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String, placeID: String) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            let placesClient = GMSPlacesClient()
            placesClient.lookUpPlaceID(placeID, callback: {
                (place, error) -> Void in
                
                var pl: GMSPlace
                pl = place!
                
                
                
                print(place?.name)
                print(place?.formattedAddress)
                print(place?.types[0])
                
                if(pl.name != nil){
                    self.placeName = pl.name
                }
                if(pl.formattedAddress != nil){
                    self.placeAddress = pl.formattedAddress
                }
                if(pl.phoneNumber != nil){
                    self.placePhone = pl.phoneNumber
                }
                if(pl.types != nil){
                    self.placeType = pl.types[0] as! String
                }
                if(pl.website != nil){
                    self.placeWebsite = pl.website
                }
                self.placeID = pl.placeID
                self.placeLongitude = pl.coordinate.longitude as Double
                self.placeLatitude = pl.coordinate.latitude as Double
                
                self.place1 = googlePlace(name: self.placeName, address: self.placeAddress, coordinate: CLLocationCoordinate2D(latitude: self.placeLatitude, longitude: self.placeLongitude), type: self.placeType, phoneNumber: self.placePhone, website: self.placeWebsite, id: self.placeID)
                self.mapView.clear()
                
                self.mapView.camera = GMSCameraPosition.cameraWithTarget(self.place1.coordinate, zoom: 15)
                //glblUser.places.append(self.place1)
                let marker = PlaceMarker(place: self.place1)
                marker.map = self.mapView
                
                
                self.RetrieveData({() in
                })
            })
            
            let position = CLLocationCoordinate2DMake(self.place1.coordinate.latitude, self.place1.coordinate.latitude)
            let marker = GMSMarker(position: position)
            
            let camera  = GMSCameraPosition.cameraWithLatitude(self.place1.coordinate.latitude, longitude: self.place1.coordinate.latitude, zoom: 10)
            self.mapView.camera = camera
            
            marker.title = title
            marker.map = self.mapView
            
            //self.RetrieveData({() in
            //})
            //SAM-------------------- add an "OPENED" relationship for this place1
        }
    }
    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String){
            let visibleRegion = self.mapView.projection.visibleRegion()
            let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.nearRight)
            
            let filter = GMSAutocompleteFilter()
            filter.type = GMSPlacesAutocompleteTypeFilter.Address
            filter.type = GMSPlacesAutocompleteTypeFilter.Establishment
            
            let placesClient = GMSPlacesClient()
            placesClient.autocompleteQuery(searchText, bounds: bounds, filter: filter) { (results, error:NSError?) -> Void in
                self.resultsArray.removeAll()
                self.searchResultController.placeIDsArray.removeAll()
                if results == nil {
                    return
                }
                for result in results!{
                    if let result = result as? GMSAutocompletePrediction{
                        self.resultsArray.append(result.attributedFullText.string)
                        self.searchResultController.placeIDsArray.append(result.placeID)
                    }
                }
                self.searchResultController.reloadDataWithArray(self.resultsArray)
            }
    }
    // ------------------------------------ Search bar stuff ends
    
    @IBAction func clickedSearchButton(sender: UIBarButtonItem) {
        //--------------------------------------make previous info Bar disappear
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        infoViewBottomButton.layer.opacity = 0.0
        infoViewRateButton.layer.opacity = 0.0
        infoViewGoThereButton.layer.opacity = 0.0
        infoSemiCircle.layer.opacity = 0.0
        infoType.layer.opacity = 0.0
        //let mapInsets = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0)
        let mapInsets = UIEdgeInsetsMake(0.0, 0.0, screenHeight/14, 0)
        mapView.padding = mapInsets
        //--------------------------------------make previous info Bar disappear
        
        let northEast = CLLocationCoordinate2DMake(center.latitude - 0.0001, center.longitude + 0.0001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.0001, center.longitude + 0.0001)
        //let myLocation = CLLocationCoordinate2DMake(-33.86, 151.20)
        //let viewport2 = GMSCoordinateBounds(
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                
                print("\nplace ID:  \(place.placeID)\nplace name:  \(place.name)\n place Address: \(place.formattedAddress)\nplace phone number:  \(place.phoneNumber)\nplace type:  \(place.types[0])\nplace latitude:  \(place.coordinate.latitude)\nplace longitude:  \(place.coordinate.longitude)")
                
                
                if(place.name != nil){
                    self.placeName = place.name
                }
                if(place.formattedAddress != nil){
                    self.placeAddress = place.formattedAddress
                }
                if(place.phoneNumber != nil){
                    self.placePhone = place.phoneNumber
                }
                if(place.types != nil){
                    self.placeType = place.types[0] as! String
                }
                if(place.website != nil){
                    self.placeWebsite = place.website
                }
                self.placeID = place.placeID
                self.placeLongitude = place.coordinate.longitude as Double
                self.placeLatitude = place.coordinate.latitude as Double
                
                self.place1 = googlePlace(name: self.placeName, address: self.placeAddress, coordinate: CLLocationCoordinate2D(latitude: self.placeLatitude, longitude: self.placeLongitude), type: self.placeType, phoneNumber: self.placePhone, website: self.placeWebsite, id: self.placeID)
                self.mapView.clear()
                
                
                //
                //What camera posiiton is this?
                //
                self.mapView.camera = GMSCameraPosition.cameraWithTarget(place.coordinate, zoom: 15)
                glblUser.places.append(self.place1)
                let marker = PlaceMarker(place: self.place1)
                marker.map = self.mapView
                //glblUser.places.append(self.place1)
                //OPEN RELATIONSHIP
                //
                //
                //
                
                self.RetrieveData({() in
                })
                
                
            } else {
                print("no place selected")
            }
        })
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "toMoreInfo"){
            let destVC = segue.destinationViewController as! moreInfoViewController
            
            destVC.Place = self.place1
            destVC.userLatitude = self.mapView.myLocation.coordinate.latitude
            destVC.userLongitude = self.mapView.myLocation.coordinate.longitude
            
            if(rateButtonClicked){
                destVC.rateState = true
                rateButtonClicked = false
            }
        }
        if(segue.identifier == "toFriendsMap"){
            let destVC = segue.destinationViewController as! friendsMapsTableViewController
            destVC.bloggersfriends = "friends"
        }
        if(segue.identifier == "toFriendProfile"){
            let destVC = segue.destinationViewController as! mainUserProfileViewController
            destVC.currentState = "friendProfile"
            destVC.friend1 = self.friend1
        }
    }
    //-------------------------------------------- infoView BOTTOM BAR create and show button begins
    
    
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        let screenHeight = view.frame.size.height
        let screenWidth = view.frame.size.width
        infoViewBottomButton.layer.opacity = 0.0
        infoViewRateButton.layer.opacity = 0.0
        infoViewGoThereButton.layer.opacity = 0.0
        infoSemiCircle.layer.opacity = 0.0
        infoType.layer.opacity = 0.0
        //let mapInsets = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0)
        let mapInsets = UIEdgeInsetsMake(0.0, 0.0, screenHeight/14, 0)
        mapView.padding = mapInsets
        
    }
    
    func showInfoViewBottomBar(place: googlePlace){
        let screenWidth = view.frame.size.width
        let screenHeight = self.view.frame.size.height
        let buttonWidth = screenWidth as CGFloat
        //let buttonHeight = 50.0 as CGFloat
        let buttonHeight = screenHeight/14
        
        //let mapInsets = UIEdgeInsetsMake(0.0, 0.0, 125.0, 0)
        let mapInsets = UIEdgeInsetsMake(0.0, 0.0, screenHeight/5.5, 0)
        mapView.padding = mapInsets
        
        
        infoViewBottomButton.removeFromSuperview()
        infoViewRateButton.removeFromSuperview()
        infoViewGoThereButton.removeFromSuperview()
        infoSemiCircle.removeFromSuperview()
        infoType.removeFromSuperview()
        
        //---------------BOTTOM BAR info window UI begins
        //infoViewBottomButton = UIButton(frame: CGRectMake(0, screenHeight-buttonHeight*2, screenWidth, buttonHeight+2))
        infoViewBottomButton = UIButton(frame: CGRectMake(0, screenHeight-buttonHeight*2, screenWidth, buttonHeight*1.5))
        infoViewBottomButton.backgroundColor = UIColor.whiteColor()
        
        //
        //----------------Rate button UI
        //
        //infoViewRateButton = UIButton(frame: CGRectMake(screenWidth*0.815,screenHeight-buttonHeight*2.6, 55, 55))
        infoViewRateButton = UIButton(frame: CGRectMake(screenWidth*0.83,screenHeight-buttonHeight*2.7, 54, 54))
        infoViewRateButton.setTitle("Rate", forState: UIControlState.Normal)
        infoViewRateButton.backgroundColor = UIColor.whiteColor()
        infoViewRateButton.layer.cornerRadius = infoViewRateButton.frame.width/2
        infoViewRateButton.clipsToBounds = true
        infoViewRateButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        //
        //-----------------Segue to more info view with the button of the screen showing
        //
        infoViewRateButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        infoViewGoThereButton = UIButton(frame: CGRectMake(screenWidth*0.05,screenHeight-buttonHeight*3.5, 60, 60))
        infoViewGoThereButton.backgroundColor = UIColor.whiteColor()
        infoViewGoThereButton.layer.cornerRadius = infoViewRateButton.frame.width/12
        infoViewGoThereButton.clipsToBounds = true
        infoViewGoThereButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        //
        //------------------Go there button UI
        //
        infoViewGoThereButton = UIButton(frame: CGRectMake(screenWidth*0.05,screenHeight-buttonHeight*3.5, 60, 60))
        infoViewGoThereButton.backgroundColor = UIColor.whiteColor()
        infoViewGoThereButton.layer.cornerRadius = infoViewRateButton.frame.width/12
        infoViewGoThereButton.clipsToBounds = true
        infoViewGoThereButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        //
        //-------------------Semi Circle UI
        //
        infoSemiCircle = UIImageView(frame: CGRectMake(screenWidth*0.4, screenHeight-buttonHeight*2.8, screenWidth*0.2, buttonHeight*1.5))
        infoSemiCircle.backgroundColor = UIColor.whiteColor()
        infoSemiCircle.layer.cornerRadius = infoSemiCircle.frame.size.width/2
        infoSemiCircle.clipsToBounds = true
        
        //
        //-------------------Semi Type UI
        //
        infoType = UIImageView(frame: CGRectMake(screenWidth*0.409, screenHeight-buttonHeight*2.72, screenHeight*0.1, screenWidth*0.1))
        infoType.contentMode = .ScaleAspectFit
        
        
        let infoViewWidth = infoViewBottomButton.frame.size.width
        let infoViewHeight = infoViewBottomButton.frame.size.height
        
        
        //infoViewRateButton = UIButton(frame: CGRectMake(screenWidth*(8/10), screenHeight-buttonHeight*2, screenWidth*(2/10), buttonHeight+2))
        //infoViewRateButton.backgroundColor = UIColor.whiteColor()
        
        //place name shizzle
        //let placeNameLabel = UILabel(frame: CGRectMake(5, 2, infoViewWidth*0.65, infoViewHeight/2))
        let placeNameLabel = UILabel(frame: CGRectMake(5, 0, infoViewWidth*0.65, infoViewHeight/4))
        placeNameLabel.text = place.name
        
        placeNameLabel.numberOfLines = 1
        placeNameLabel.adjustsFontSizeToFitWidth = true
        placeNameLabel.textAlignment = .Center
        //place address shizzle
        let placeAddressLabel = UILabel(frame: CGRectMake(0, 0, infoViewWidth*0.5, infoViewHeight*0.55))
        //let placeAddressLabel = UILabel(frame: CGRectMake(5, 21, infoViewWidth, infoViewHeight/2))
        placeAddressLabel.font = UIFont(name: placeAddressLabel.font.fontName, size: infoViewHeight/5)
        placeAddressLabel.text = place.address
        
        //place food shizzle
        let placeFoodLabel = UILabel(frame: CGRectMake(infoViewWidth*0.05, infoViewHeight*0.5, infoViewWidth*0.1, infoViewHeight/5))
        //let placeFoodLabel = UILabel(frame: CGRectMake(infoViewWidth*0.05, infoViewHeight*0.5, infoViewWidth*(8/10), infoViewHeight/5))
        placeFoodLabel.font = UIFont(name: placeAddressLabel.font.fontName, size: infoViewHeight/4)
        placeFoodLabel.font = placeFoodLabel.font.fontWithSize(10)
        placeFoodLabel.text = "Food"
        placeFoodLabel.textAlignment = .Center
        
        //foodSlider = UIImageView(frame: CGRectMake(infoViewWidth*0.05, 25, infoViewWidth/4, infoViewHeight/3.5))
        //foodSlider = UIImageView(frame: CGRectMake(infoViewWidth*0.05, 25, infoViewWidth/4, infoViewHeight/5))
        foodSlider = UIImageView(frame: CGRectMake(infoViewWidth*0.05, infoViewHeight*0.3, infoViewWidth/4, infoViewHeight/5))
        foodSlider.contentMode = .ScaleAspectFit
        //foodSlider.image = UIImage(named: "newSliderCafe\(place.avgFood)")
        
        //place service shizzle
        let placeServiceLabel = UILabel(frame: CGRectMake(infoViewWidth*0.43, infoViewHeight*0.5, infoViewWidth*0.2, infoViewHeight/5))
        //let placeServiceLabel = UILabel(frame: CGRectMake(infoViewWidth*0.38, infoViewHeight*0.5, infoViewWidth*(8/10), infoViewHeight/5))
        placeServiceLabel.font = UIFont(name: placeAddressLabel.font.fontName, size: infoViewHeight/4)
        placeServiceLabel.font = placeServiceLabel.font.fontWithSize(10)
        placeServiceLabel.text = "Service"
        placeServiceLabel.textAlignment = .Center
        
        //serviceSlider = UIImageView(frame: CGRectMake(infoViewWidth*0.38, 25, infoViewWidth/4, infoViewHeight/3.5))
        serviceSlider = UIImageView(frame: CGRectMake(infoViewWidth*0.38, infoViewHeight*0.3, infoViewWidth/4, infoViewHeight/5))
        serviceSlider.contentMode = .ScaleAspectFit
        
        //place atmosphere shizzle
        let placeAtmosphereLabel = UILabel(frame: CGRectMake(infoViewWidth*0.72, infoViewHeight*0.5, infoViewWidth*0.2, infoViewHeight/3.5))
        //let placeAtmosphereLabel = UILabel(frame: CGRectMake(infoViewWidth*0.7, infoViewHeight*0.5, infoViewWidth*(8/10), infoViewHeight/3.5))
        placeAtmosphereLabel.font = UIFont(name: placeAddressLabel.font.fontName, size: infoViewHeight/4)
        placeAtmosphereLabel.font = placeAtmosphereLabel.font.fontWithSize(10)
        placeAtmosphereLabel.text = "Atmosphere"
        placeAtmosphereLabel.textAlignment = .Center
        
        //atmoSlider = UIImageView(frame: CGRectMake(infoViewWidth*0.7, 25, infoViewWidth/4, infoViewHeight/5))
        atmoSlider = UIImageView(frame: CGRectMake(infoViewWidth*0.7, infoViewHeight*0.3, infoViewWidth/4, infoViewHeight/5))
        atmoSlider.contentMode = .ScaleAspectFit
        
        //
        //----------------Text color
        //
        placeNameLabel.textColor = UIColor.whiteColor()
        placeAddressLabel.textColor = UIColor.whiteColor()
        placeFoodLabel.textColor = UIColor.whiteColor()
        placeServiceLabel.textColor = UIColor.whiteColor()
        placeAtmosphereLabel.textColor = UIColor.whiteColor()
        
        if(place.placeType == "cafe"){
            
            infoViewBottomButton.backgroundColor = glblColor.cafeDarkColor
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereCafe.jpeg"), forState: UIControlState.Normal)
            
            //
            //slider bars
            //
            foodSlider.image = UIImage(named: "newSliderCafe\(place.avgFood).jpeg")
            serviceSlider.image = UIImage(named: "newSliderCafe\(place.avgService).jpeg")
            atmoSlider.image = UIImage(named: "newSliderCafe\(place.avgAtmosphere).jpeg")
            
            //
            //been there and go there buttons and type of place symbol
            //
            infoViewRateButton.setTitleColor(glblColor.cafeDarkColor, forState: UIControlState.Normal)
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereCafe.jpeg"), forState: UIControlState.Normal)
            infoSemiCircle.backgroundColor = glblColor.cafeDarkColor
            
            //
            ///type button UI
            //
            infoType.image = UIImage(named: "moreInfoCafeIcon.jpeg")
            
        }
        else if(place.placeType == "restaurant" || place.placeType == "meal_takeaway" || place.placeType == "street_address" || place.placeType == "food" || place.placeType == "grocery_or_supermarket"){

            infoViewBottomButton.backgroundColor = glblColor.foodDarkColor
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereFood.jpeg"), forState: UIControlState.Normal)
            
            //
            //slider bars
            //
            foodSlider.image = UIImage(named: "newSliderFood\(place.avgFood).jpeg")
            serviceSlider.image = UIImage(named: "newSliderFood\(place.avgService).jpeg")
            atmoSlider.image = UIImage(named: "newSliderFood\(place.avgAtmosphere).jpeg")
            
            //
            //been there and go there buttons and type of place symbol
            //
            infoViewRateButton.setTitleColor(glblColor.foodDarkColor, forState: UIControlState.Normal)
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereFood.jpeg"), forState: UIControlState.Normal)
            infoSemiCircle.backgroundColor = glblColor.foodDarkColor
            
            //
            ///type button UI
            //
            infoType.image = UIImage(named: "moreInfoFoodIcon.jpeg")
            
        }
        else if(place.placeType == "entertainment"){
            
            infoViewBottomButton.backgroundColor = glblColor.eventsDarkColor
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereEvents.jpeg"), forState: UIControlState.Normal)
            
            //
            //slider bars
            //
            foodSlider.image = UIImage(named: "newSliderEvents\(place.avgFood).jpeg")
            serviceSlider.image = UIImage(named: "newSliderEvents\(place.avgService).jpeg")
            atmoSlider.image = UIImage(named: "newSliderEvents\(place.avgAtmosphere).jpeg")
            
            //
            //been there and go there buttons and type of place symbol
            //
            infoViewRateButton.setTitleColor(glblColor.eventsDarkColor, forState: UIControlState.Normal)
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereEvents.jpeg"), forState: UIControlState.Normal)
            infoSemiCircle.backgroundColor = glblColor.eventsDarkColor
            
            //
            ///type button UI
            //
            infoType.image = UIImage(named: "moreInfoEventsIcon.jpeg")
            
            
        }
        else if(place.placeType == "store" || place.placeType == "home_goods_store" || place.placeType == "department_store" || place.placeType == "clothing_store" || place.placeType == "shoe_store"){
            
            infoViewBottomButton.backgroundColor = glblColor.retailDarkColor
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereRetail.jpeg"), forState: UIControlState.Normal)
            
            //
            //slider bars
            //
            foodSlider.image = UIImage(named: "newSliderRetail\(place.avgFood).jpeg")
            serviceSlider.image = UIImage(named: "newSliderRetail\(place.avgService).jpeg")
            atmoSlider.image = UIImage(named: "newSliderRetail\(place.avgAtmosphere).jpeg")
            
            //
            //been there and go there buttons and type of place symbol
            //
            infoViewRateButton.setTitleColor(glblColor.retailDarkColor, forState: UIControlState.Normal)
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereRetail.jpeg"), forState: UIControlState.Normal)
            infoSemiCircle.backgroundColor = glblColor.retailDarkColor
            
            //
            ///type button UI
            //
            infoType.image = UIImage(named: "moreInfoRetailIcon.jpeg")
            
        }
        else if(place.placeType == "bar" || place.placeType == "night_club"){

            infoViewBottomButton.backgroundColor = glblColor.drinksDarkColor
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereDrinks.jpeg"), forState: UIControlState.Normal)
            
            //
            //slider bars
            //
            foodSlider.image = UIImage(named: "newSliderDrinks\(place.avgFood).jpeg")
            serviceSlider.image = UIImage(named: "newSliderDrinks\(place.avgService).jpeg")
            atmoSlider.image = UIImage(named: "newSliderDrinks\(place.avgAtmosphere).jpeg")
            
            //
            //been there and go there buttons and type of place symbol
            //
            infoViewRateButton.setTitleColor(glblColor.drinksDarkColor, forState: UIControlState.Normal)
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereDrinks.jpeg"), forState: UIControlState.Normal)
            infoSemiCircle.backgroundColor = glblColor.drinksDarkColor
            
            
            //
            ///type button UI
            //
            infoType.image = UIImage(named: "moreInfoDrinksIcon.jpeg")
            
        } else{
            
            infoViewBottomButton.backgroundColor = glblColor.eventsDarkColor
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereEvents.jpeg"), forState: UIControlState.Normal)
            
            //
            //slider bars
            //
            foodSlider.image = UIImage(named: "newSliderEvents\(place.avgFood).jpeg")
            serviceSlider.image = UIImage(named: "newSliderEvents\(place.avgService).jpeg")
            atmoSlider.image = UIImage(named: "newSliderEvents\(place.avgAtmosphere).jpeg")
            
            //
            //been there and go there buttons and type of place symbol
            //
            infoViewRateButton.setTitleColor(glblColor.eventsDarkColor, forState: UIControlState.Normal)
            infoViewGoThereButton.setBackgroundImage(UIImage(named: "moreInfoGoThereEvents.jpeg"), forState: UIControlState.Normal)
            infoSemiCircle.backgroundColor = glblColor.eventsDarkColor
            
            //
            ///type button UI
            //
            infoType.image = UIImage(named: "moreInfoEventsIcon.jpeg")
            
        }
        
        //infoViewBottomButton.setTitle("\(place.name)", forState: UIControlState.Normal)
        infoViewBottomButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //self.view.addSubview(infoSemiCircle)
        //self.view.addSubview(infoType)
        self.view.addSubview(infoViewBottomButton)
        self.view.addSubview(infoViewRateButton)
        //self.view.addSubview(infoViewGoThereButton)
        
        
        //----------------add subview to the semi circle
        //infoSemiCircle.addSubview(infoType)
        
        //----------------add subviews to the bottom bar
        
        infoViewBottomButton.addSubview(placeNameLabel)
        //infoViewBottomButton.addSubview(placeAddressLabel)
        infoViewBottomButton.addSubview(placeFoodLabel)
        infoViewBottomButton.addSubview(foodSlider)
        infoViewBottomButton.addSubview(placeServiceLabel)
        infoViewBottomButton.addSubview(serviceSlider)
        infoViewBottomButton.addSubview(placeAtmosphereLabel)
        infoViewBottomButton.addSubview(atmoSlider)
        //placeNameLabel.center = CGPointMake(infoViewBottomButton.bounds.midX, 12)
        placeNameLabel.center = CGPointMake(infoViewBottomButton.bounds.midX, infoViewHeight/7.5)
        placeNameLabel.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        //
        //----------------manual UI Constraints on the sliders and labels
        //
        serviceSlider.center = CGPointMake(infoViewBottomButton.bounds.midX, infoViewHeight*0.4)
        placeServiceLabel.center = CGPointMake(infoViewBottomButton.bounds.midX, infoViewHeight*0.6)
        foodSlider.center = CGPointMake(infoViewBottomButton.bounds.midX-(screenWidth*0.35), infoViewHeight*0.4)
        placeFoodLabel.center = CGPointMake(infoViewBottomButton.bounds.midX-(screenWidth*0.35), infoViewHeight*0.6)
        atmoSlider.center = CGPointMake(infoViewBottomButton.bounds.midX+(screenWidth*0.35), infoViewHeight*0.4)
        placeAtmosphereLabel.center = CGPointMake(infoViewBottomButton.bounds.midX+(screenWidth*0.35), infoViewHeight*0.6)
        
        
        //----------------BOTTOM BAR info window UI ends
    }
    
    //-------------------------------------------- infoView BOTTOM BAR create and show button ends
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        // 1
        let placeMarker = marker as! PlaceMarker
        
        //------------------------------------------------------------- infoView BOTTOM BAR create and show button begins
        showInfoViewBottomBar(placeMarker.place)
        //-------------------------------------------------------------- infoView BOTTOM BAR create and show button ends
        
        //if(currentState = )
        self.place1 = placeMarker.place
        GetNumReviews()
        // 2
        /*if let infoView = UIView.viewFromNibName("infoView") as? MarkerInfoView {
        // 3
        infoView.placeName.text = placeMarker.place.name
        var plc = self.place1
        infoView.bubbleBackground.image = UIImage(named: "bubbleCafe.jpg")
        if(placeMarker.place.placeType == "cafe"){
        infoView.bubbleBackground.image = UIImage(named: "bubbleCafe.jpg")
        infoView.atmosphereSlider.image = UIImage(named: "newSliderCafe\(plc.avgAtmosphere).jpg")
        infoView.foodSlider.image = UIImage(named: "sliderCafe\(plc.avgFood).jpg")
        infoView.serviceSlider.image = UIImage(named: "sliderCafe\(plc.avgService).jpg")
        }else if(placeMarker.place.placeType == "restaurant" || placeMarker.place.placeType == "meal_takeaway" || placeMarker.place.placeType == "street_address" || placeMarker.place.placeType == "food" || placeMarker.place.placeType == "grocery_or_supermarket"){
        infoView.bubbleBackground.image = UIImage(named: "bubbleFood.jpg")
        infoView.atmosphereSlider.image = UIImage(named: "sliderFood\(plc.avgAtmosphere).jpg")
        infoView.foodSlider.image = UIImage(named: "sliderFood\(plc.avgFood).jpg")
        infoView.serviceSlider.image = UIImage(named: "sliderFood\(plc.avgService).jpg")
        }else if(placeMarker.place.placeType == "bar" || placeMarker.place.placeType == "night_club"){
        infoView.bubbleBackground.image = UIImage(named: "bubbleDrinks.jpg")
        infoView.atmosphereSlider.image = UIImage(named: "sliderDrinks\(plc.avgAtmosphere).jpg")
        infoView.foodSlider.image = UIImage(named: "sliderDrinks\(plc.avgFood).jpg")
        infoView.serviceSlider.image = UIImage(named: "sliderDrinks\(plc.avgService).jpg")
        }else if(placeMarker.place.placeType == "entertainment"){
        infoView.bubbleBackground.image = UIImage(named: "bubbleEvents.jpg")
        infoView.atmosphereSlider.image = UIImage(named: "sliderEvents\(plc.avgAtmosphere).jpg")
        infoView.serviceSlider.image = UIImage(named: "sliderEvents\(plc.avgService).jpg")
        infoView.foodSlider.image = UIImage(named: "sliderEvents\(plc.avgFood).jpg")
        }else if(placeMarker.place.placeType == "store" || placeMarker.place.placeType == "home_goods_store" || placeMarker.place.placeType == "department_store" || placeMarker.place.placeType == "clothing_store" || placeMarker.place.placeType == "shoe_store"){
        infoView.bubbleBackground.image = UIImage(named: "bubbleRetail.jpg")
        infoView.atmosphereSlider.image = UIImage(named: "sliderRetail\(plc.avgAtmosphere).jpg")
        infoView.foodSlider.image = UIImage(named: "sliderRetail\(plc.avgFood).jpg")
        infoView.serviceSlider.image = UIImage(named: "sliderRetail\(plc.avgService).jpg")
        }
        infoView.backgroundColor = UIColor.clearColor()
        infoView.layer.cornerRadius = 50.0
        // 4
        /*if let photo = placeMarker.place.photo {
        infoView.placePhoto.image = photo
        } else {
        infoView.placePhoto.image = UIImage(named: "generic")
        }*/
        
        return infoView
        } else {
        return nil
        }*/
        return nil
    }
    
    
    @IBOutlet weak var TabButton: UIBarButtonItem!
    
    //
    //What camera position does this change?
    //Changes the zoom of an individual user when they first open the app
    //
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first as CLLocation!{
            //if(currentState == "mainMap"){
            self.currentLocation = locations.first as CLLocation!
            self.center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            self.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 15)
            mapView.camera = self.camera
            print("\n\n\nUser's location is: \(location.coordinate.latitude) latitude and \(location.coordinate.longitude) longitude \n\n\n", terminator: "")
            //}
        }
        else{
            camera = GMSCameraPosition.cameraWithLatitude(33.4294, longitude: -111.9431, zoom: 6)
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        
        let placeMarker = marker as! PlaceMarker
        
        self.place1 = placeMarker.place
        //did corey do this right???
        performSegueWithIdentifier("toMoreInfo", sender: self)
        //did corey do this right???
        
    }
    
    func buttonAction(sender:UIButton!)
    {
        if(sender == infoViewBottomButton){
            performSegueWithIdentifier("toMoreInfo", sender: self)
        }
        else if(sender == infoViewRateButton){
            rateButtonClicked = true
            performSegueWithIdentifier("toMoreInfo", sender: self)
        }
            //search bar stufff begins
        else if(sender == self.searchButton){
            //--------------------------------------make previous info Bar disappear
            //
            //will need to make more stuff opaque
            //
            infoViewBottomButton.layer.opacity = 0.0
            infoViewRateButton.layer.opacity = 0.0
            infoViewGoThereButton.layer.opacity = 0.0
            //--------------------------------------make previous info Bar disappear
            print("search tapped")
            let searchController = UISearchController(searchResultsController: searchResultController)
            searchController.searchBar.delegate = self
            self.presentViewController(searchController, animated: true, completion: nil)
            //----------------------------------did not make the search bar go away
            //searchButton.removeFromSuperview()
            //searchButton.layer.opacity = 0.0
        }
            //search bar stufff begins
        else if(sender == self.myMapButton){
            print("myMap tapped")
            if(currentState != "mainMap"){
                performSegueWithIdentifier("toHomeMap", sender: self)
            }
        }else if(sender == self.friendNameButton){
            performSegueWithIdentifier("toFriendProfile", sender: self)
        }else if(sender == self.bloggersButton){
            toFriendsBloggersMaps = "bloggers"
            print("house tapped this is the bloggers button")
            RetrieveNumOfBloggers()
        }else if(sender == self.friendsButton){
            print("friends tapped")
            toFriendsBloggersMaps = "friends"
            performSegueWithIdentifier("toFriendsMap", sender: self)
        }else if(sender == self.followFriendButton){
            print("follow friends tapped")
            glblUser.currentState = "mainMap"
            
            
            func AddFriendRelationship() {
                
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
                theo.fetchNode("\(glblUser.friend1.id)", completionBlock: {(node, error) in
                    
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
                    print(dateFormatter.stringFromDate(date))
                    print(timeFormatter.stringFromDate(date))
                    relationship.relate(parentNode!, toNode: relatedNode!, type: RelationshipType.FOLLOWS)
                    relationship.setProp("Date", propertyValue: "\(dateFormatter.stringFromDate(date))")
                    relationship.setProp("Time", propertyValue: "\(timeFormatter.stringFromDate(date))")
                    theo.createRelationship(relationship, completionBlock: {(rel, error) in
                        self.performSegueWithIdentifier("toHomeMap", sender: self)
                    })
                })
            }
            var userAlreadyFriend = false
            for var temp in glblUser.friends{
                if (glblUser.friend1.email == temp.email){
                    userAlreadyFriend = true
                    self.followFriendButton.setTitle("Currently Following", forState: UIControlState.Normal)                }
            }
            if (!userAlreadyFriend){
                AddFriendRelationship()
                glblUser.numOfFriends++
                glblUser.friends.append(friend1)
            }
            
            
        }
        
        
    }
    func searchBarAction(sender:UISearchBar){
        print("search bar tapped")
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    //search bar stufff begins
    let searchButton   = UIButton(type: UIButtonType.System)
    let threeLinesButton     = UIButton(type: UIButtonType.System)
    //search bar stufff ends
    let myMapButton   = UIButton(type: UIButtonType.System)
    let bloggersButton   = UIButton(type: UIButtonType.System)
    let friendsButton   = UIButton(type: UIButtonType.System)
    var toFriendsBloggersMaps = "friends"
    
    let friendNameButton   = UIButton(type: UIButtonType.System)
    let followFriendButton   = UIButton(type: UIButtonType.System)
    let followingFriendButton = UIButton(type: UIButtonType.System)
    
    override func viewDidLayoutSubviews() {
        
        let barView = UIImageView(image: UIImage(named: "Main_Bottom Buttons Divider.jpg"))
        let barView1 = UIImageView(image: UIImage(named: "Main_Bottom Buttons Divider.jpg"))
        
        let screenWidth = view.frame.size.width
        let screenHeight = self.view.frame.size.height
        let buttonWidth = screenWidth/3 as CGFloat
        let buttonHeight = 50.0 as CGFloat
        let button2X = (screenWidth)/2 - buttonWidth/2
        //Sam or Ahmed help Corey ;-)
        //let navigationBarHeight = navigationController!.navigationBar.frame.size.height as CGFloat
        let navigationBarHeight = screenHeight/10.5 as CGFloat
        
        print(screenHeight)
        
        //----------------------------------------search bar stufff begins
        if(navigationController != nil){
            searchButton.frame = CGRectMake(0,0,navigationController!.navigationBar.frame.width/2, navigationController!.navigationBar.frame.height*0.9)
        }
        
        searchButton.setBackgroundImage(UIImage(named: "searchBar.jpg"), forState: UIControlState.Normal)
        searchButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = searchButton
        /*
        searchButton.frame = CGRectMake(0, 0, navigationController!.navigationBar.frame.width/2, navigationController!.navigationBar.frame.height*0.9)
        searchButton.setBackgroundImage(UIImage(named: "searchBar.jpg"), forState: UIControlState.Normal)
        searchButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        searchButton.layer.cornerRadius = searchButton.frame.size.width/2
        navigationItem.titleView = searchButton
        */
        
        
        
        //-----------------------------------------search bar stufff ends
        
        bloggersButton.frame = CGRectMake(0, screenHeight-buttonHeight, buttonWidth, buttonHeight)
        bloggersButton.setBackgroundImage(UIImage(named: "Main_Home Button Inactive.jpg"), forState: UIControlState.Normal)
        bloggersButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //self.view.addSubview(bloggersButton)
        
        myMapButton.frame = CGRectMake(button2X, screenHeight-buttonHeight, buttonWidth, buttonHeight)
        myMapButton.setBackgroundImage(UIImage(named: "Main_Map Button Inactive.jpg"), forState: UIControlState.Normal)
        myMapButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // self.view.addSubview(myMapButton)
        
        friendsButton.frame = CGRectMake(screenWidth-buttonWidth, screenHeight-buttonHeight, buttonWidth, buttonHeight)
        friendsButton.setBackgroundImage(UIImage(named: "Main_Friend Button Inactive.jpg"), forState: UIControlState.Normal)
        friendsButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //self.view.addSubview(friendsButton)
        
        barView.frame = CGRect(x: screenWidth-buttonWidth, y: screenHeight-buttonHeight, width: 5, height: buttonHeight)
        barView1.frame = CGRect(x: screenWidth-buttonWidth*2.0, y: screenHeight-buttonHeight, width: 5, height: buttonHeight)
        barView.contentMode = .ScaleAspectFit
        barView1.contentMode = .ScaleAspectFit
        bloggersButton.contentMode = .ScaleAspectFit
        myMapButton.contentMode = .ScaleAspectFit
        friendsButton.contentMode = .ScaleAspectFit
        //self.view.addSubview(barView)
        //self.view.addSubview(barView1)
        
        
        if(self.currentState == "friendMap"){
            //friendNameButton.frame = CGRectMake(0, 0, screenWidth/2, buttonHeight)
            friendNameButton.frame = CGRectMake(0, navigationBarHeight, screenWidth/2, buttonHeight)
            friendNameButton.backgroundColor = glblColor.traverseGray
            friendNameButton.setTitle(friend1.firstName + " " + friend1.lastName, forState: UIControlState.Normal)
            friendNameButton.setTitleColor(glblColor.activeBlue, forState: UIControlState.Normal)
            friendNameButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(friendNameButton)
            
            //followingFriendButton.frame = CGRectMake(screenWidth/2, 0, screenWidth/2, buttonHeight)
            followingFriendButton.frame = CGRectMake(screenWidth/2, navigationBarHeight, screenWidth/2, buttonHeight)
            followingFriendButton.backgroundColor = glblColor.traverseGray
            followingFriendButton.setTitle("Currently Following", forState: UIControlState.Normal)
            followingFriendButton.setTitleColor(glblColor.activeBlue, forState: UIControlState.Normal)
            followingFriendButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(followingFriendButton)
            
            ///self.friendsButton.setBackgroundImage(UIImage(named: "Main_Friend Button Active.jpg"), forState: UIControlState.Normal)
        }
        if(self.currentState == "followMap"){
            
            //friendNameButton.frame = CGRectMake(0, 0, screenWidth, buttonHeight)
            friendNameButton.frame = CGRectMake(0, navigationBarHeight, screenWidth, buttonHeight)
            friendNameButton.backgroundColor = glblColor.traverseGray
            friendNameButton.setTitle(currentBlogger.maps[currentBloggerMapNo].name, forState: UIControlState.Normal)
            friendNameButton.setTitleColor(glblColor.activeBlue, forState: UIControlState.Normal)
            //friendNameButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(friendNameButton)
            
            //followFriendButton.frame = CGRectMake(screenWidth/2, 0, screenWidth/2, buttonHeight)
            followFriendButton.frame = CGRectMake(screenWidth/2, navigationBarHeight, screenWidth/2, buttonHeight)
            followFriendButton.backgroundColor = glblColor.traverseGray
            followFriendButton.setTitle("follow", forState: UIControlState.Normal)
            followFriendButton.setTitleColor(glblColor.activeBlue, forState: UIControlState.Normal)
            followFriendButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            //self.bloggersButton.setBackgroundImage(UIImage(named: "Main_Home Button Active.jpg"), forState: UIControlState.Normal)
            
        }
        else if(glblUser.currentState == "potentialFriendMap"){
            
            //friendNameButton.frame = CGRectMake(0, 0, screenWidth/2, buttonHeight)
            friendNameButton.frame = CGRectMake(0, navigationBarHeight, screenWidth/2, buttonHeight)
            friendNameButton.backgroundColor = glblColor.traverseGray
            friendNameButton.setTitle(glblUser.friend1.firstName + " " + glblUser.friend1.lastName, forState: UIControlState.Normal)
            friendNameButton.setTitleColor(glblColor.activeBlue, forState: UIControlState.Normal)
            friendNameButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(friendNameButton)
            
            //followFriendButton.frame = CGRectMake(screenWidth/2, 0, screenWidth/2, buttonHeight)
            followFriendButton.frame = CGRectMake(screenWidth/2, navigationBarHeight, screenWidth/2, buttonHeight)
            followFriendButton.backgroundColor = glblColor.traverseGray
            followFriendButton.setTitle("click to follow", forState: UIControlState.Normal)
            followFriendButton.setTitleColor(glblColor.activeBlue, forState: UIControlState.Normal)
            followFriendButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(followFriendButton)
        }
        
        if(self.currentState == "mainMap"){
            //self.myMapButton.setBackgroundImage(UIImage(named: "Main_Map Button Active.jpg"), forState: UIControlState.Normal)
            
        }
        
    }
    
    func RetrieveBlogger(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:Blogger) return a.NickName"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var count = 0
            while(count < glblUser.numOfBloggers){
                print(cypher!.data[0]["a.NickName"]! as! String)
                let nickname = cypher!.data[0]["a.NickName"]! as! String
                let blgr = blogger()
                blgr.nickname = nickname
                blgr.firstName = nickname
                glblUser.bloggers.append(blgr)
                print(glblUser.bloggers.count)
                print(glblUser.bloggers[0])
                count++
            }
            self.performSegueWithIdentifier("toFriendsMap", sender: self)
            //self.performSegueWithIdentifier("toBloggersList", sender: self)
        })
    }
    func RetrieveNumOfBloggers(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a:Blogger) return count(a)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            glblUser.numOfBloggers = cypher!.data[0]["count(a)"]! as! Int
            print(cypher!.data[0]["count(a)"]! as! Int)
            if(glblUser.bloggers.count == 0){
                self.RetrieveBlogger()
            }
            else{
                self.performSegueWithIdentifier("toFriendsMap", sender: self)
                //self.performSegueWithIdentifier("toBloggersList", sender: self)
            }
        })
    }
    
    
    var nodeID = 0;
    var neoID = "neoID"
    
    func CreatePlaceNode(){
        print("hit me")
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let x = "label"
        let node = Node()
        
        node.setProp("ID", propertyValue: self.placeID)
        node.setProp("Name", propertyValue: self.placeName)
        node.setProp("Address", propertyValue: self.placeAddress)
        //node.setProp("Website", propertyValue: self.website)
        node.setProp("Longitude", propertyValue: self.placeLongitude)
        node.setProp("Latitude", propertyValue: self.placeLatitude)
        node.setProp("Type", propertyValue: self.placeType)
        node.setProp("Phone Number", propertyValue: self.placePhone)
        node.setProp("HasReviews", propertyValue: "FALSE")
        //node.setProp("Review Text", propertyValue: self.reviewText)
        node.addLabel("" + x)
        
        theo.createNode(node, completionBlock: {(node, error) in
            print("new node \(node)")
            self.updateData({() in
            })
        });
    }
    func updateData(completion: () -> Void){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH(n {ID: '\(self.placeID)'}) Return n.Name, n.Latitude, n.Longitude, n.Address, n.ID, n.Website, n.`Phone Number`, n.Type, id(n)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            self.placeName = cypher!.data[0]["n.Name"]! as! String
            self.placeAddress = cypher!.data[0]["n.Address"]! as! String
            //self.latitude = cypher!.data[0]["n.Latitude"]! as! String
            //self.longitude = cypher!.data[0]["n.Longitude"]! as! String
            //self.web = cypher!.data[0]["n.Website"]! as! String
            self.placePhone = cypher!.data[0]["n.`Phone Number`"]! as! String
            self.placeType = cypher!.data[0]["n.Type"]! as! String
            self.placeID = cypher!.data[0]["n.ID"]! as! String
            self.nodeID = cypher!.data[0]["id(n)"]! as! Int
            self.neoID = String(self.nodeID)
            self.AddRelationship()
            self.RetrieveAvg()
            print(cypher!.data[0]["n.Name"]! as! String)
            print("ohGawd")
            print("yay")
        })
        
    }
    //TO DO - ADD ERROR HANDLING FOR WEBSITES
    func RetrieveData(completion: () -> Void){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH(n {ID: '\(placeID)'}) Return n.Name, n.Latitude, n.Longitude, n.Address, n.ID, n.Website, n.`Phone Number`, n.Type, id(n)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            if (cypher != nil && cypher!.data.count > 0)
            {
                print(cypher!.data[0])
                self.placeName = cypher!.data[0]["n.Name"]! as! String
                self.placeAddress = cypher!.data[0]["n.Address"]! as! String
                //self.latitude = cypher!.data[0]["n.Latitude"]! as! String
                //self.longitude = cypher!.data[0]["n.Longitude"]! as! String
                //self.web = cypher!.data[0]["n.Website"]! as! String
                self.placePhone = cypher!.data[0]["n.`Phone Number`"]! as! String
                self.placeType = cypher!.data[0]["n.Type"]! as! String
                self.placeID = cypher!.data[0]["n.ID"]! as! String
                self.nodeID = cypher!.data[0]["id(n)"]! as! Int
                self.neoID = String(self.nodeID)
                self.InsertAsPlace()
                self.AddRelationship()
                print("yay")
                
            }
            else
            {
                self.CreatePlaceNode()
            }
        })
        
    }
    
    func RetrieveAvg(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH(n {ID: '\(placeID)'}) Return n.Name, n.Latitude, n.Longitude, n.Address, n.ID, n.Website, n.`Phone Number`, n.Type, id(n)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            if (cypher != nil && cypher!.data.count > 0)
            {
                print(cypher!.data[0])
                self.placeName = cypher!.data[0]["n.Name"]! as! String
                self.placeAddress = cypher!.data[0]["n.Address"]! as! String
                //self.latitude = cypher!.data[0]["n.Latitude"]! as! String
                //self.longitude = cypher!.data[0]["n.Longitude"]! as! String
                //self.web = cypher!.data[0]["n.Website"]! as! String
                self.placePhone = cypher!.data[0]["n.`Phone Number`"]! as! String
                self.placeType = cypher!.data[0]["n.Type"]! as! String
                self.placeID = cypher!.data[0]["n.ID"]! as! String
                self.nodeID = cypher!.data[0]["id(n)"]! as! Int
                self.neoID = String(self.nodeID)
                self.RetrieveHasReviews()
            }
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
            print(dateFormatter.stringFromDate(date))
            print(timeFormatter.stringFromDate(date))
            relationship.relate(parentNode!, toNode: relatedNode!, type: RelationshipType.OPEN)
            relationship.setProp("Date", propertyValue: "\(dateFormatter.stringFromDate(date))")
            relationship.setProp("Time", propertyValue: "\(timeFormatter.stringFromDate(date))")
            
            theo.createRelationship(relationship, completionBlock: {(rel, error) in
                self.RetrieveAvg()
                self.InsertAsPlace()
            })
        })
    }
    
    func RetrieveHasReviews(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (c) where c.ID = '\(place1.id)' return c.HasReviews"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            print(self.nodeID)
            print(cypher!.data[0]["c.HasReviews"]! as! String)
            if(cypher!.data[0]["c.HasReviews"]! as! String == "TRUE")
            {
                self.CalcAverageRatings()
            }
            else{
                print("Does not have reviews")
            }
        })
    }
    func CalcAverageRatings(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:REVIEW]-(c:Place) where c.ID = '\(place1.id)' return avg(b.Food) as averageFood, avg(b.Service) as averageService, avg(b.Atmosphere) as averageAtmosphere"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            self.place1.avgFood = Int(round(cypher!.data[0]["averageFood"]! as! Double))
            self.place1.avgService = Int(round(cypher!.data[0]["averageService"]! as! Double))
            self.place1.avgAtmosphere = Int(round(cypher!.data[0]["averageAtmosphere"]! as! Double))
            print(self.place1.avgFood)
            print(self.place1.avgService)
            print(self.place1.avgAtmosphere)
            self.GetNumReviews()
        })
    }
    
    func GetNumReviews(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:REVIEW]-(c:Place) where c.ID = '\(place1.id)' return count(b.ReviewText)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            self.numOfReviews = cypher!.data[0]["count(b.ReviewText)"]! as! Int
            self.GetReviews()
        })
    }
    
    func GetReviews(){
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "match (a)-[b:REVIEW]-(c:Place) where c.ID = '\(place1.id)' return b.ReviewText, a.FirstName, a.LastName, b.Time, b.Date, b.Food, b.Service, b.Atmosphere, c.Type, c.Name, c.Address"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            var count = 0
            while (count < self.numOfReviews)
            {
                self.place1.reviews = cypher!.data[count]["b.ReviewText"]! as! String
                self.place1.tips.append(self.place1.reviews)
                self.place1.tipMakers.append("\(cypher!.data[count]["a.FirstName"]! as!String) \(cypher!.data[count]["a.LastName"]! as!String)")
                self.place1.tipPlaceName.append("\(cypher!.data[count]["c.Name"]! as!String)")
                self.place1.tipPlaceType.append("\(cypher!.data[count]["c.Type"]! as!String)")
                self.place1.tipPlaceAddress.append("\(cypher!.data[count]["c.Address"]! as!String)")
                self.place1.tipReviewDate.append("\(cypher!.data[count]["b.Date"]! as!String)")
                self.place1.tipReviewTime.append("\(cypher!.data[count]["b.Time"]! as!String)")
                self.place1.tipFoodRating.append(cypher!.data[count]["b.Food"]! as!Int)
                self.place1.tipServiceRating.append(cypher!.data[count]["b.Service"]! as!Int)
                self.place1.tipAtmoRating.append(cypher!.data[count]["b.Atmosphere"]! as!Int)
                count++
            }
            self.SecondRetrieveData()
        })
    }
    func SecondAddRelationship() {
        
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
            print(dateFormatter.stringFromDate(date))
            print(timeFormatter.stringFromDate(date))
            relationship.relate(parentNode!, toNode: relatedNode!, type: RelationshipType.GLANCED)
            relationship.setProp("Date", propertyValue: "\(dateFormatter.stringFromDate(date))")
            relationship.setProp("Time", propertyValue: "\(timeFormatter.stringFromDate(date))")
            relationship.setProp("Longitude", propertyValue: "\(self.mapView.myLocation.coordinate.longitude)")
            relationship.setProp("Latitude", propertyValue: "\(self.mapView.myLocation.coordinate.latitude)")
            
            
            theo.createRelationship(relationship, completionBlock: {(rel, error) in
                self.InsertAsPlace()
            })
        })
    }
    
    func SecondRetrieveData(){
        
        //let url: String = "http://ec2-52-3-120-155.compute-1.amazonaws.com"
        //let theo: Client = Client(baseURL: url, user: "neo4j", pass: "7ducksrw")
        let url: String = glblUser.serverLink
        let theo: Client = Client(baseURL: url, user: glblUser.serverUse, pass: glblUser.serverPass)
        let cyperQuery: String = "MATCH(n {ID: '\(place1.id)'}) Return n.Name, n.Latitude, n.Longitude, n.Address, n.ID, n.Website, n.`Phone Number`, n.Type, id(n)"
        let cyperParams: Dictionary<String, AnyObject> = ["user" : "neo4j"]
        //let completionBlock: TheoCypherQueryCompletionBlock
        //theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: )
        theo.executeCypher(cyperQuery, params: cyperParams, completionBlock: {(cypher, error) in
            if (cypher != nil && cypher!.data.count > 0)
            {
                print(cypher!.data[0])
                self.placeName = cypher!.data[0]["n.Name"]! as! String
                self.placeAddress = cypher!.data[0]["n.Address"]! as! String
                //self.latitude = cypher!.data[0]["n.Latitude"]! as! String
                //self.longitude = cypher!.data[0]["n.Longitude"]! as! String
                //self.web = cypher!.data[0]["n.Website"]! as! String
                self.placePhone = cypher!.data[0]["n.`Phone Number`"]! as! String
                self.placeType = cypher!.data[0]["n.Type"]! as! String
                self.placeID = cypher!.data[0]["n.ID"]! as! String
                self.nodeID = cypher!.data[0]["id(n)"]! as! Int
                self.neoID = String(self.nodeID)
                self.InsertAsPlace()
                self.SecondAddRelationship()
            }
            else
            {
                self.CreatePlaceNode()
            }
        })
        
    }
    
    
}