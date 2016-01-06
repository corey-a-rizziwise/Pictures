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
    var uploadRequests = Array<AWSS3TransferManagerUploadRequest?>()
    var uploadFileURLs = Array<NSURL?>()
    
    @IBOutlet var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        for (_, imageDictionary) in info.enumerate() {

                            let fileName = "AHMEDTRYINSTUFF".stringByAppendingString(".png")
                            let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent("upload").URLByAppendingPathComponent(fileName)
                            let filePath = fileURL.path!
                            let imageData = UIImagePNGRepresentation(img)
                            imageData!.writeToFile(filePath, atomically: true)
                            
                            let uploadRequest = AWSS3TransferManagerUploadRequest()
                            uploadRequest.body = fileURL
                            uploadRequest.key = fileName
                            uploadRequest.bucket = S3BucketName
                            
                            self.uploadRequests.append(uploadRequest)
                            
                            self.uploadFileURLs.append(nil)
                            
                            self.upload(uploadRequest)


        }

    }

    

    func upload(uploadRequest: AWSS3TransferManagerUploadRequest) {
        showState()
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
                    if let index = self.indexOfUploadRequest(self.uploadRequests, uploadRequest: uploadRequest) {
                        self.uploadRequests[index] = nil
                        self.uploadFileURLs[index] = uploadRequest.body
                    }
                })
            }
            self.showState()
            return nil
        }
        showState()
    }
    func indexOfUploadRequest(array: Array<AWSS3TransferManagerUploadRequest?>, uploadRequest: AWSS3TransferManagerUploadRequest?) -> Int? {
        for (index, object) in array.enumerate() {
            if object == uploadRequest {
                return index
            }
        }
        return nil
    }
    
    func showState(){
        if(self.uploadRequests.count>0){
            if let uploadRequest = self.uploadRequests[0] {
                switch uploadRequest.state {
                case .Running:
                    uploadRequest.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if totalBytesExpectedToSend > 0 {
                                print("----------------------------------running")
                                print( Float(Double(totalBytesSent) / Double(totalBytesExpectedToSend)))
                            }
                        })
                    }
                    
                    break;
                    
                default:
                    print("-------------------------------not running")
                    
                }
            }
        }

    }

}

