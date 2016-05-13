//
//  SettingsTableViewController.swift
//  Heartboxx
//
//  Created by dev on 5/3/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import ImagePicker
import Alamofire
import SwiftSpinner
import KeychainSwift
import AlamofireImage


class SettingsTableViewController: UITableViewController, ImagePickerDelegate {
    let imagePickerController = ImagePickerController()

    let keychain = KeychainSwift()

    @IBOutlet var imgProfile: UIImageView!
    
    let imageCache = AutoPurgingImageCache()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.imageTapped(_:)))
        
        imgProfile.addGestureRecognizer(tapGesture)
        imgProfile.userInteractionEnabled = true
        
        
        
        loadAvatar()
        
        
        
        
   
            }
   
    
    func loadAvatar(){
        let uid = keychain.get("HB_uid")!

        let URL = NSURL(string: API_Domain + "/uploads/profiles/"+uid+".jpg")!
       
         
        imgProfile.af_setImageWithURL(URL)
        
        
           }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            launchCapture()
            //Here you can initiate your new ViewController
            
        }
   }
    
    func launchCapture() {
        
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)

    }
    func wrapperDidPress(images: [UIImage]) {
        // print ("wrap")
    }
    
    func doneButtonDidPress(images: [UIImage]){
        
        
        let image = images[0]
        
        
        SwiftSpinner.show("Uploading...").addTapHandler({
            SwiftSpinner.hide()
        })
        let uid = keychain.get("HB_uid")!

        // define parameters
        let parameters = [
            "uid": uid,
            ]
        
        // Begin upload
        Alamofire.upload(.POST, URL_profile_upload,
                         // define your headers here
            multipartFormData: { multipartFormData in
                
                // import image to request
                if let imageData = UIImageJPEGRepresentation(image, 0.7) {
                    multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "myImage.jpg", mimeType: "image/png")
                }
                
                // import parameters
                for (key, value) in parameters {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
            }, // you can customise Threshold if you wish. This is the alamofire's default value
            encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                     SwiftSpinner.hide()
                    upload.responseJSON { response in
                        debugPrint(response)
                        self.dismissViewControllerAnimated(true, completion: {
                       //     print("donneonoe")

                            self.imgProfile.image = image
                   //         self.imageCache.addImage(image, withIdentifier: "avatar")

                        })
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
        
        
        
        // Begin upload
        
        
    }
    
    
    func cancelButtonDidPress(){
        
        //print ("canc")
    }
    
    func logout () {
     
       let common = Common();
        common.logout()
    }

    
}
