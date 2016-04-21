//
//  ViewController.swift
//  Heartboxx
//
//  Created by dev on 4/21/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    
    @IBOutlet var txtSearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtSearch.layer.borderWidth = 1
        txtSearch.layer.borderColor = UIColor.blackColor().CGColor
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

