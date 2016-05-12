//
//  EditProfile.swift
//  Heartboxx
//
//  Created by dev on 5/7/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import ImagePicker
import Alamofire

class EditProfileController: UIViewController,ImagePickerDelegate {

    
    override func viewDidLoad() {
        
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        
        super.viewDidLoad()
       
    }
    
    func wrapperDidPress(images: [UIImage]) {
       // print ("wrap")
    }
    
    func doneButtonDidPress(images: [UIImage]){
        
        
        let image = images[0]
        
        
        
     
        
        
        
      
        
        
        
        
        
        
        // define parameters
        let parameters = [
            "uid": "27",
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
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
        
        
     
        
  
        
       
        /*
        Alamofire.request(
            .POST,
            "http://192.168.0.111/heartboxx/users/profileimg",
            parameters: ["uid": "27"],
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error connecting remote: \(response.result.error)")
                    //  completion(nil)
                    return
                }
            //    let res = JSON(response.result.value!)
                
                
                
                
        }
        */
        
        print ("wat")
        // Begin upload
      /*  Alamofire.upload(.POST, URL_profile_upload,
                         // define your headers here
          //  headers: ["Authorization": "auth_token"],
            multipartFormData: { multipartFormData in
                
                // import image to request
                if let imageData = UIImageJPEGRepresentation(image, 1) {
                    multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "profile.png", mimeType: "image/png")
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
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
 */
        
    }
    func cancelButtonDidPress(){
        
        //print ("canc")
    }
}
