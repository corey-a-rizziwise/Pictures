//
//  ViewController.swift
//  picture
//
//  Created by ahmed moussa on 1/3/16.
//  Copyright © 2016 ahmed moussa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet var image: UIImageView!
    @IBAction func imageButtonAction(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let theInfo = info as NSDictionary
        let img = theInfo.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
        
        image.image = img
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

