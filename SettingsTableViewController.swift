//
//  SettingsTableViewController.swift
//  Heartboxx
//
//  Created by dev on 5/3/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import KeychainSwift
import AlamofireImage


class SettingsTableViewController: UITableViewController {

    let keychain = KeychainSwift()


    @IBOutlet var imgProfile: UIImageView!
    
    @IBOutlet var footerView: UIView!
    
    let imageCache = AutoPurgingImageCache()

    var capturedImage = UIImage()
    var isCaptured = false
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.imageTapped(_:)))
        
        imgProfile.addGestureRecognizer(tapGesture)
        imgProfile.isUserInteractionEnabled = true
        tableView.tableFooterView = footerView
        
        
        if(isCaptured) {
            self.imgProfile.image = capturedImage
            self.clearImageCache()
        }else {
         loadAvatar()
        }
//

        
        
        
         
   
            }
   
    
    @IBAction func btnLogout(_ sender: AnyObject) {
        clearImageCache()
        
        keychain.delete("HB_uid")
        keychain.delete("HB_sgcnt")
        
 
         self.navigationController?.popToRootViewController(animated: true)
    }

    func clearImageCache(){
        let uid = keychain.get("HB_uid")!
        let URL1 = URL(string: API_Domain + "/uploads/profiles/"+uid+".jpg")!
        
        let imageDownloader = UIImageView.af_sharedImageDownloader
        let urlRequest = URLRequest(url: URL1)
      
                imageDownloader.imageCache?.removeImage(for: urlRequest, withIdentifier: nil)
    }
    
    func loadAvatar(){
        let uid = keychain.get("HB_uid")!

        let URL1 = URL(string: API_Domain + "/uploads/profiles/"+uid+".jpg")!
       
         
        imgProfile.af_setImage(withURL: URL1)
        
        
           }
    
    func imageTapped(_ gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            
            
            
            
            launchCapture()
            //Here you can initiate your new ViewController
            
        }
   }
    
    func launchCapture() {
        
     //  presentViewController(imagePickerController, animated: true, completion: nil)
        
        
        let vc: CameraViewController? = self.storyboard?.instantiateViewController(withIdentifier: "CameraView") as? CameraViewController
        if let validVC: CameraViewController = vc {
            
         self.navigationController?.pushViewController(validVC, animated: true)
            
        }
        

    }
    func wrapperDidPress(_ images: [UIImage]) {
        // print ("wrap")
    }
    
    func doneButtonDidPress(_ images: [UIImage]){
        
        
        
       
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
       
        if (segue.identifier == "WebViewSegue") {
            // pass data to next view
            let wv = segue.destination as? WebViewViewController

            wv!.browserURL =  API_Domain + "/about.php"
        }
    }
    
    func cancelButtonDidPress(){
        
        //print ("canc")
    }
    
    

    
}
