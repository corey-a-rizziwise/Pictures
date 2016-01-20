//
//  tutorialViewController.swift
//  Traverse
//
//  Created by Corey Rizzi-Wise on 12/13/15.
//  Copyright © 2015 Samuel Wang. All rights reserved.
//

import UIKit

class tutorialViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tutorialTitle: UILabel!
    @IBOutlet var backgroundView: UIView!
    
    
    @IBOutlet weak var friendsListView: UIImageView!
    
    
    
    override func viewDidLayoutSubviews() {
        //shizzle
        //friendsListView.layer.borderWidth = 2
        //friendsListView.layer.borderColor = glblColor.activeBlue.CGColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSizeMake(view.frame.size.width, 4000)
        backButton.backgroundColor = glblColor.traverseGray
        scrollView.backgroundColor = UIColor.whiteColor()
        backgroundView.backgroundColor = glblColor.traverseGray
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
