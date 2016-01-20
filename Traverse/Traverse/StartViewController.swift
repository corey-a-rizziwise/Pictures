//
//  ViewController.swift
//  Traverse
//
//  Created by Samuel Wang on 9/29/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

/*
Overview of funcitonality

General xCode needs this to function 
*/
import UIKit

class StartViewController: UIViewController {

    @IBOutlet var signup: UIButton!
    @IBOutlet var login: UIButton!
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(43200, target: self, selector: Selector("Notification"), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func Notification(){
        
        let Notification = UILocalNotification()
        Notification.alertAction = "Come Back!"
        Notification.alertBody = "What Delicious Noms Have You Eaten Today?"
        
        Notification.fireDate = NSDate(timeIntervalSinceNow: 0)
        
        UIApplication.sharedApplication().scheduleLocalNotification(Notification)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

