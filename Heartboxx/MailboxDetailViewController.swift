//
//  MailboxDetailViewController.swift
//  Heartboxx
//
//  Created by dev on 5/12/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit

class MailboxDetailViewController: UITableViewController {
    
    @IBOutlet var lblTo: UILabel!
    
    @IBOutlet var lblSubject: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblBody: UILabel!
    var to =  String()
    var body = String()
    var subject = String()
    var date = String()
    override func viewWillAppear(animated: Bool) {
        //  print (venueName)
        //print (address)
        self.title = to
        lblBody.text = body
        lblTo.text = to
        lblSubject.text = subject
        lblDate.text = date
        //   blogNameLabel.text = blogName
    }

    
}
