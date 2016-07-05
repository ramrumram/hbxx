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
//let URL_profile_upload = "http://thepressengine.com:8080/heartboxx/profile_image.php"
//let API_Domain = "http://thepressengine.com:8080/heartboxx"
var device_id = ""
var notificationPlaceObj = NSDictionary()
class Common {
    
    let keychain = KeychainSwift()

 
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

    
    func  saveBckStatus(status: String) -> Void {
        
        let uid = keychain.get("HB_uid")!
       Alamofire.request(
            .POST,
            API_Domain + "/api/users/savebackgroundlocationstatus",
            parameters: ["uid": uid, "status" : status],
            encoding: .URL)
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
