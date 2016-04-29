//
//  Meal.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/26/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit
import Alamofire
import SwiftyJSON

class History {
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
