//
//  NewMessageController.swift
//  Heartboxx
//
//  Created by dev on 5/4/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//


import UIKit
import Alamofire
import KeychainSwift
import SwiftSpinner


class NewMessageController: UITableViewController {

    let keychain = KeychainSwift()
    @IBOutlet var txtTo: UITextField!
    
    @IBOutlet var txtMessage: UITextView!
    
    @IBOutlet var txtCC: UITextField!
    
    
    @IBOutlet var txtSub: UITextField!
    
    var venueName =  String()
    var address = String()
    override func viewWillAppear(animated: Bool) {
      //  print (venueName)
        //print (address)
        
        txtTo.text = venueName
        txtMessage.text = address
     //   blogNameLabel.text = blogName
    }
    
    
    @IBAction func btnSend(sender: AnyObject) {
        
        
        
        
        //print ("clicked")
        let uid = keychain.get("HB_uid")
        let message = venueName + " " + address
        
        
        
        let params = ["uid": uid!, "message" : message, "to" : venueName, "subject": txtSub.text!]

        SwiftSpinner.show("Sending...").addTapHandler({
            SwiftSpinner.hide()
        })
        Alamofire.request(
            .POST,
            API_Domain+"/api/messages/suggestion",
            parameters: params,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print(response)
                    print("Error connecting remote: \(response.result.error)")
                    //  completion(nil)
                    return
                }
               
                print (response)
                SwiftSpinner.hide({
                    self.navigationController?.popViewControllerAnimated(true)
                })
                
                
                //let res = JSON(response.result.value!)
               // rows = String(res["success"])
                
    }
    }
    
    
    
}
