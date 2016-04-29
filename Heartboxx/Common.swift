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
                    print("Error while fetching remote rooms: \(response.result.error)")
                    //  completion(nil)
                    return
                }
                let res = JSON(response.result.value!)
                rows = String(res["success"])
                
                
                
               
        }
        
        //  completion(rooms)
        
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
                    print("Error while fetching remote rooms: \(response.result.error)")
                    //  completion(nil)
                    return
                }
                let res = JSON(response.result.value!)
                print(res["success"])
                
                // guard let value = response.result.value as? [String: AnyObject],
                /*rows = value["rows"] as? [[String: AnyObject]] else {
                 print ("sss")
                 print("Malformed data received from fetchAllRooms service")
                 // completion(nil)
                 return
                 }
                 */
                
                
                //  var rooms = [RemoteRoom]()
                //   for roomDict in rows {
                //   rooms.append(RemoteRoom(jsonData: roomDict))
        }
        
        //  completion(rooms)
        
        return rows
    }
    
}
