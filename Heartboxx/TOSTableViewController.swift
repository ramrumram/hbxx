//
//  TOSTableViewController.swift
//  Heartboxx
//
//  Created by dev on 5/18/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit

class TOSTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let wv = segue.destinationViewController as? WebViewViewController
        
        if (segue.identifier == "AckSegue") {
            // pass data to next view
            
            
            wv!.browserURL =  API_Domain + "/ack.php"
        }else if(segue.identifier == "TOSSegue") {
            wv!.browserURL =  API_Domain + "/TOS.php"
        }else if(segue.identifier == "PPSegue") {
            wv!.browserURL =  API_Domain + "/PP.php"
            
        }else if(segue.identifier == "CookieSegue") {
            wv!.browserURL =  API_Domain + "/cookie.php"
            
        }
        
    }

}
