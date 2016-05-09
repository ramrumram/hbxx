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

let URL_profile_upload = "http://192.168.0.111/heartboxx/profile_image.php"

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
    
    func  postLog(description: String) -> AnyObject {
        
        var rows = ""
        Alamofire.request(
            .POST,
            "http://192.168.0.111/heartboxx/log",
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
