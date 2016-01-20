//
//  ViewController.swift
//  picture
//
//  Created by ahmed moussa on 1/3/16.
//  Copyright © 2016 ahmed moussa. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var downloadRequest = AWSS3TransferManagerDownloadRequest()
    var downloadFileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("AHMEDTRYINSTUFF.png")
    
    
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadRequest!.bucket = S3BucketName
        downloadRequest!.key = "AHMEDTRYINSTUFF.png"
        downloadRequest!.downloadingFileURL = downloadFileURL
        download()
        self.image.image = UIImage(contentsOfFile: self.downloadFileURL.path!)
    }
    
    func download(){
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        transferManager.download(downloadRequest).continueWithBlock({ (task) -> AnyObject! in
            if let error = task.error {
                if error.domain == AWSS3TransferManagerErrorDomain as String
                    && AWSS3TransferManagerErrorType(rawValue: error.code) == AWSS3TransferManagerErrorType.Paused {
                        print("Download paused. \n")
                } else {
                    print("download failed: [\(error)] \n")
                }
            } else if let exception = task.exception {
                print("download failed: [\(exception)] \n")
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    print("i'm in download()  ")
                    self.downloadRequest.downloadProgress = { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if (totalBytesExpectedToWrite > 0) {
                                print("------------------------------ downloading")
                                print( Float(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)))
                            }
                            else{
                                print("------------------------------- not downloading")
                            }
                        })
                    }

                    self.downloadFileURL = self.downloadRequest.downloadingFileURL
                })
            }
            if((task.result) != nil){
                print("downloaded??")
                print(self.downloadFileURL.path!)
                self.image.image = UIImage(contentsOfFile: self.downloadFileURL.path!)
                if let data = task.result!.data {
                    print("idek man")
                    
                }
                
            }
            return nil
        })
        

    }
    
    @IBAction func imageButtonAction(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let theInfo = info as NSDictionary
        let img = theInfo.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
        
        image.image = img
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

