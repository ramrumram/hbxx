//
//  Common.swift
//  Heartboxx
//
//  Created by dev on 4/28/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import KeychainSwift

let URL_profile_upload = "http://192.168.0.111/heartboxx/profile_image.php"
let API_Domain = "http://192.168.0.111/heartboxx"

class Common {
    // MARK: Properties
    
    //  var name: String
    // var photo: UIImage?
    // var category: String
    
    // MARK: Initialization
    
    /* init?(name: String, photo: UIImage?, category: String) {
     // Initialize stored properties.
     self.name = name
     self.photo = photo
     self.category = category
     
     // Initialization should fail if there is no name or if the rating is negative.
     if name.isEmpty  {
     return nil
     }
     }*/
    
    let keychain = KeychainSwift()

    
    func logout() {
        let uid = keychain.get("HB_uid")!
        let URL = NSURL(string: API_Domain + "/uploads/profiles/"+uid+".jpg")!
        
        let imageDownloader = UIImageView.af_sharedImageDownloader
        let urlRequest = NSURLRequest(URL: URL)
        imageDownloader.imageCache?.removeImageForRequest(urlRequest, withAdditionalIdentifier: nil)
        
        keychain.delete("HB_uid")

    }
    func  postLog(description: String) -> AnyObject {
        
        var rows = ""
        Alamofire.request(
            .POST,
            API_Domain + "/api/log",
            parameters: ["description": description],
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error connecting remote: \(response.result.error)")
                    //  completion(nil)
                    return
                }
                let res = JSON(response.result.value!)
                rows = String(res["success"])
                
                
                
               
        }
        
        
        return rows
    }

    
    func  getRecent() -> AnyObject {
        
        let rows = [String : AnyObject]()
        Alamofire.request(
            .GET,
            "http://192.168.0.111/heartboxx/",
            parameters: ["include_docs": "true"],
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote : \(response.result.error)")
                    //  completion(nil)
                    return
                }
                let res = JSON(response.result.value!)
                print(res["success"])
                
              
        }
        
        
        return rows
    }
    
}






extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func trunc(length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
        } else {
            return self
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.numberOfTapsRequired=2
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SequenceType {
    var minimalDescrption: String {
        return map { String($0) }.joinWithSeparator(",")
    }
}
