//
//  TermsConditionsViewControllers.swift
//  Traverse
//
//  Created by Samuel Wang on 10/5/15.
//  Copyright (c) 2015 Traverse Technologies. All rights reserved.
//

import UIKit

class TermsConditionsViewControllers: UIViewController {

    @IBOutlet weak var TermsAndConditionsTextBox: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TermsAndConditionsTextBox.editable = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidLayoutSubviews() {
        backButton.backgroundColor = glblColor.traverseGray
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
