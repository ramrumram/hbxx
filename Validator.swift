//
//  Validator.swift
//  Heartboxx
//
//  Created by dev on 5/10/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//


import Foundation
import UIKit


class Validator {
    // MARK: Properties
    
   
    
    
    func validate(validations:Dictionary<Int, NSMutableArray>) -> Bool {
        
        var i = 0;
        var valid = false;
        
       while i < validations.count {
        let field = (validations[i])!
        i = i+1;
        
        let rules = field[2] as! NSArray
        let uiobj = field[0] as! UITextField
        let errobj = field[1] as! UILabel
        let textval = uiobj.text?.trim()
        
        var j=0;
        while j < rules.count {
            //rules[j] wil be email, not-empty etc.,
            switch rules[j] as! String {
                case "not-empty":
                    if(textval == "" || textval == nil) {
                        errobj.text = "Field cannot be empty"
                        uiobj.layer.borderColor = UIColor.yellowColor().CGColor
                        uiobj.layer.cornerRadius = 5
                        uiobj.layer.borderWidth = 1.0
                        valid = false
                        return valid
                    }else {
                        errobj.text = ""
                        uiobj.layer.borderWidth = 0.0
                        valid = true
                    }
                    
                break;
                
                case "email":
                    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
                    if(emailPredicate.evaluateWithObject(textval) != true) {
                        errobj.text = "Invalid email"
                        uiobj.layer.borderColor = UIColor.yellowColor().CGColor
                        uiobj.layer.cornerRadius = 5
                        uiobj.layer.borderWidth = 1.0
                        valid = false
                        return valid
                    }else {
                        errobj.text = ""
                        uiobj.layer.borderWidth = 0.0
                        valid = true
                    }
                   
                break;
                default:
                    valid = true
                    break;
            }
            j = j+1;
        }
        
        }
      
       
       
        return valid
    }
    
    
}