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

//let URL_profile_upload = "http://192.168.2.17:8081/heartboxx/profile_image.php"
//let API_Domain = "http://192.168.2.17:8081/heartboxx"

//let URL_profile_upload = "http://heartboxx.com/heartboxx/profile_image.php"
//let API_Domain = "http://heartboxx.com/heartboxx"

let URL_profile_upload = "http://hub-web.net/heartboxx/profile_image.php"
let API_Domain = "http://hub-web.net/heartboxx"



var device_id = ""
var notificationPlaceObj = NSDictionary()
class Common {
    
    let keychain = KeychainSwift()

 
    func  postLog(_ description: String) -> AnyObject {
        
        var rows = ""
        Alamofire.request(
      
            API_Domain + "/api/log",
              method: .post,
            parameters: ["description": description],
            encoding: URLEncoding.default)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error connecting remote: \(response.result.error)")
                    //  completion(nil)
                    return
                }
                let res = JSON(response.result.value!)
                rows = String(describing: res["success"])
        }
        
        
        return rows as AnyObject
    }

    
    func  saveBckStatus(_ status: String) -> Void {
        
        let uid = keychain.get("HB_uid")!
       Alamofire.request(
            API_Domain + "/api/users/savebackgroundlocationstatus",
            method: .post,
            parameters: ["uid": uid, "status" : status],
            encoding: URLEncoding.default)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error connecting remote: \(response.result.error)")
                    //  completion(nil)
                    return
                }
                
        }
        
   }
    
    
}



extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func trunc(_ length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
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
    
    func hideKeyboardWhenSingleTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.numberOfTapsRequired=1
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Sequence {
    var minimalDescrption: String {
        return map { String(describing: $0) }.joined(separator: ",")
    }
}


