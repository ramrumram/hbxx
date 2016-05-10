//
//  LoginViewController.swift
//  Heartboxx
//
//  Created by dev on 5/9/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import KeychainSwift
import Alamofire
import SwiftSpinner
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var lblError: UILabel!
    
    
    @IBOutlet var lblError1: UILabel!
    
    let keychain = KeychainSwift()
    
    let Fields = ["Email", "Password"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        
        var dict = Dictionary<Int, NSMutableArray>()
        dict[0] = [txtEmail, lblError, ["not-empty", "email"] ] as NSMutableArray
        dict[1] = [txtPassword, lblError1, ["not-empty"]] as NSMutableArray
        
        
        
        let validator = Validator()
        
        if(validator.validate(dict)) {
            
            
            SwiftSpinner.show("Aunthenticating...")
            
            Alamofire.request(
                .POST,
                API_Domain + "/api/login",
                parameters: ["email": txtEmail.text!, "password": txtPassword.text!],
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    SwiftSpinner.hide()
                    guard response.result.isSuccess else {
                        print("Error connecting remote: \(response.result.error)")
                        //  completion(nil)
                        return
                    }
                    let res = JSON(response.result.value!)
                    if let uid = res["uid"].string {
                          self.keychain.set(uid, forKey: "HB_uid")
                          self.goToHome()
                    }
                    
                  
     //
                    
                    //print ()
                    
                    
            }
            
        }
        
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        //   blogNameLabel.text = blogName
        
        //will try going to homeviewcontroller
        goToHome()
    }
    
    func goToHome() {
        //check if already logged in
        if (keychain.get("HB_uid") != nil) {
            let storyboard = UIStoryboard(name: "User", bundle: nil)
            
            let rootController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController")
            
            
            
            self.navigationController?.pushViewController(rootController, animated: true)
        }
    }
    
}
