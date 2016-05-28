//
//  PrivacyViewController.swift
//  Heartboxx
//
//  Created by dev on 5/18/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit
import KeychainSwift
import SwiftSpinner


class PrivacyViewController: UITableViewController {

    let common = Common()
    let keychain = KeychainSwift()

    @IBOutlet var switchBkgnd: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSwitchStatus()
   //     LoginViewController().stopBackgroud()
        
 
    }
    @IBAction func backgroundChanged(sender: UISwitch) {
        if (sender.on == true) {
            LoginViewController().startBackgroud()
        }else {
            LoginViewController().stopBackgroud()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func backgroundSwitchStatus() {
        
        SwiftSpinner.show("Updating...")
        let uid = keychain.get("HB_uid")!
        var status = ""
        Alamofire.request(
            .GET,
            API_Domain + "/api/users/getbackgroundlocationstatus",
            parameters: ["uid": uid],
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
                status =  res["background_status"].stringValue
              //  print(status)
                if (status == "1") {
                    self.switchBkgnd.setOn(true, animated: false)
                }else{
                    self.switchBkgnd.setOn(false, animated: false)
                }
                
                
        }

    }
}
