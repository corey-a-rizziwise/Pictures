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
    var uploadRequest = AWSS3TransferManagerUploadRequest()
    var uploadFileURL = NSURL()
    
    var downloadRequest = AWSS3TransferManagerDownloadRequest()
    var downloadFileURL = NSURL()
    
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         //----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
        let error = NSErrorPointer()
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(
                NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("upload"),
                withIntermediateDirectories: true,
                attributes: nil)
        } catch let error1 as NSError {
            error.memory = error1
            print("Creating 'upload' directory failed. Error: \(error)")
        }
         //----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
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
        print("----------------------\n\n\n-------------------------\(info)")
         //----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
        let fileName = "AHMEDTRYINSTUFF2".stringByAppendingString(".png")
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("upload").URLByAppendingPathComponent(fileName)
        let filePath = fileURL.path!
        let imageData = UIImagePNGRepresentation(img)
        imageData!.writeToFile(filePath, atomically: true)
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.body = fileURL
        uploadRequest.key = fileName
        uploadRequest.bucket = S3BucketName
        
        self.uploadRequest = uploadRequest
        
        self.upload(uploadRequest)
         //----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
    }
    
    
     //----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
    func upload(uploadRequest: AWSS3TransferManagerUploadRequest) {
        showUploadState()
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                if error.domain == AWSS3TransferManagerErrorDomain as String {
                    if let errorCode = AWSS3TransferManagerErrorType(rawValue: error.code) {
                        switch (errorCode) {
                        case .Cancelled, .Paused:
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                print("not sure when this happens")
                            })
                            break;
                            
                        default:
                            print("upload() failed: [\(error)]")
                            break;
                        }
                    } else {
                        print("upload() failed: [\(error)]")
                    }
                } else {
                    print("upload() failed: [\(error)]")
                }
            }
            
            if let exception = task.exception {
                print("upload() failed: [\(exception)]")
            }
            
            if task.result != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.uploadFileURL = uploadRequest.body
                })
            }
            self.showUploadState()
            return nil
        }
        showUploadState()
    } //----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
    
     //----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
    func showUploadState(){
        switch uploadRequest.state {
        case .Running:
            uploadRequest.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if totalBytesExpectedToSend > 0 {
                        print("----------------------------------running")
                        print("\( Float(Double(totalBytesSent) / Double(totalBytesExpectedToSend))*100)%")
                    }
                })
            }
            
            break
            
        default:
            print("-------------------------------not running")
            
        }
    }//----------- --------------- -------------- ---------- UPLOAD ------------- ----------- ------------- -----------//
    
}

