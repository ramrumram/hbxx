//
//  CameraViewController.swift
//  Celebgrams
//
//  Created by dev on 9/26/16.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import UIKit
import CameraManager
import Alamofire
import SwiftSpinner
import KeychainSwift
import AlamofireImage


class CameraViewController: UIViewController {
     let keychain = KeychainSwift()
    @IBOutlet var cameraView: UIView!
    
    @IBOutlet var overlayView: UIView!
    let cameraManager = CameraManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cameraManager.showAccessPermissionPopupAutomatically = true
        cameraManager.writeFilesToPhoneLibrary = false
        
        cameraManager.flashMode = .auto
        cameraManager.cameraDevice = .front
        
        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        if currentCameraState == .notDetermined {
            
        } else if (currentCameraState == .ready) {
            addCameraToView()
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    
    fileprivate func addCameraToView()
    {
        cameraManager.cameraOutputQuality = .high
        
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    @IBAction func btnCapture(_ sender: AnyObject) {
        
        cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
            
            if let errorOccured = error {
                self.cameraManager.showErrorBlock("Error occurred", errorOccured.localizedDescription)
            }
            else {
                
                
                
                
                                
                
                //  SwiftSpinner.show("Uploading...").addTapHandler({
                //      SwiftSpinner.hide()
                //  })
                let uid = self.keychain.get("HB_uid")!
                
                // define parameters
                let parameters = [
                    "uid": uid,
                    ]
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                // Begin upload
                Alamofire.upload(
                    // define your headers here
                    multipartFormData: { multipartFormData in
                        
                        // import image to request
                        if let imageData = UIImageJPEGRepresentation(image!, 0.7) {
                            multipartFormData.append(imageData, withName: "file", fileName: "myImage.jpg", mimeType: "image/png")
                        }
                        
                        // import parameters
                        for (key, value) in parameters {
                            //                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                            
                        }
                    }, // you can customise Threshold if you wish. This is the alamofire's default value
                    to: URL_profile_upload,
                    encodingCompletion: { encodingResult in
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        switch encodingResult {
                        case .success(let upload, _, _):
                            //    SwiftSpinner.hide()
                            upload.responseJSON { response in
                                debugPrint("image uploade")
                                
                                
                                                             
                                
                                
                                let vc: SettingsTableViewController? = self.storyboard?.instantiateViewController(withIdentifier: "SettingsController") as? SettingsTableViewController
                                if let validVC: SettingsTableViewController = vc {
                                    if let capturedImage = image {
                                        
                                        
                                        validVC.capturedImage = capturedImage
                                        validVC.isCaptured = true
                                        self.navigationController?.pushViewController(validVC, animated: true)
                                    }
                                }
                                
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                })
                
                
                
              
            }
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
