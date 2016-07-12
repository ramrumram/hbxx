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


class NewMessageController: UITableViewController, UITextViewDelegate {

    let keychain = KeychainSwift()
    @IBOutlet var txtTo: UITextField!
    
    @IBOutlet var txtMessage: UITextView!
    
    @IBOutlet var txtCC: UITextField!
 
    
   
    
    @IBOutlet var txtSub: UITextField!
    
    var venueName =  String()
    var address = String()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        txtMessage.delegate = self
     self.hideKeyboardWhenTappedAround()
        
        
             
    }
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
     //   let message = venueName + " " + address
        
        
        
        let params = ["uid": uid!, "message" : txtMessage.text!, "to" : venueName, "subject": txtSub.text!]

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
                
                
            
                
               
                            //  SwiftSpinner.hide({
                    
                    
             //   })
                
                
               
                
    }
        
        var sgcnt = 1
        if (self.keychain.get("HB_sgcnt") != nil) {
            sgcnt =  Int(self.keychain.get("HB_sgcnt")!)! + 1
            
        }
        let str =  String(sgcnt)
        
        self.keychain.set(str, forKey: "HB_sgcnt")
        
        SwiftSpinner.hide();
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        
        let rootController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController")
        
        self.navigationController?.pushViewController(rootController, animated: true)
        
    }
    
    func animateTextField(textView: UITextView, up: Bool) {
        let movementDistance:CGFloat = -110
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up {
            movement = movementDistance
        }
        else {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        UIView.commitAnimations()
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
         self.animateTextField(textView, up:true)
        
    }
   
    func textViewDidEndEditing(textView: UITextView) {
        self.animateTextField(textView, up:false)
        
    }
}
