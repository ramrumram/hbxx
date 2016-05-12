//
//  NewMessageController.swift
//  Heartboxx
//
//  Created by dev on 5/4/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//


import UIKit



class NewMessageController: UIViewController {

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
    }
    
    
    
}
