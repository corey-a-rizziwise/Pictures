//
//  AppDelegate.swift
//  Traverse
//
//  Created by Samuel Wang on 9/29/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.


/*
Overview of funcitonality

General xCode needs this to function and begin creating new app
Also, includes our Goole Maps iOS API key that is registered under corey.a.rizziwise@gmail.com
*/

//Import UIKit for xCode graphics and GoogleMaps to call Google Mapping functionality
import UIKit
import GoogleMaps


//Google API Key below
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var APIKey = "AIzaSyA5KYxm-Uf-IPn2nHxZ9tVFWLw9il_YjOM"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        GMSServices.provideAPIKey(APIKey)
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: nil))
        
        //let splitViewController = window!.rootViewController as! UISplitViewController
        //let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        //navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        //splitViewController.delegate = self
        
        UISearchBar.appearance().barTintColor = UIColor.grayColor()
        UISearchBar.appearance().tintColor = UIColor.whiteColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.grayColor()
        
        return true
    }
    
//    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
//        //guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
//        //guard let topAsDetailController = secondaryAsNavController.topViewController as? mainUserProfileViewController else { return false }
//        //if topAsDetailController.detail == nil {
//            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//            return true
//        }
//        //return false
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

