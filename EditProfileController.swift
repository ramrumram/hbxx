//
//  EditProfileController.swift
//  Heartboxx
//
//  Created by dev on 5/13/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import KeychainSwift
class EditProfileController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var txtLname: UITextField!
    
    
    
    @IBOutlet var txtBio: UITextView!
    @IBOutlet var txtCity: UITextField!
    
    @IBOutlet var pickerSex: UIPickerView!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtFname: UITextField!
    var pickerData: [String] = [String]()
    
    let keychain = KeychainSwift()
    @IBOutlet var lblError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pickerSex.delegate = self
        self.pickerSex.dataSource = self
        // Input data into the Array:
        pickerData = ["I'd rather not say", "Male", "Female"]
        self.hideKeyboardWhenTappedAround()
              
        loadData()
    }
    
    
    func loadData() {
        let uid = keychain.get("HB_uid")!
        SwiftSpinner.show("loading...").addTapHandler({
            SwiftSpinner.hide()
        })
        
        Alamofire.request(
            .GET,
            API_Domain + "/api/getuser/"+uid,
            encoding: .URL)
            .validate()
            .responseJSON { (response) -> Void in
                SwiftSpinner.hide()
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    //  completion(nil)
                    return
                }
                //  let res = JSON(response.result.value!)
                //   rows["data"] =  res["history"]
                
                let value = JSON(response.result.value!)
                
                var data = value["data"]
                
                
                if let val = data["email"].string {
                    self.txtEmail.text = val
                }
                if let val = data["fname"].string {
                    self.txtFname.text = val
                }
                if let val = data["lname"].string {
                    self.txtLname.text = val
                }
                if let val = data["phone"].string {
                    self.txtPhone.text = val
                }
                if let val = data["city"].string {
                    self.txtCity.text = val
                }
                if let val = data["bio"].string {
                    self.txtBio.text = val
                }
                
                
        }
        
        
        
    }
    
    @IBAction func btnSave(sender: AnyObject) {
        
        let uid = keychain.get("HB_uid")!
        
        var dict = Dictionary<Int, NSMutableArray>()
        dict[0] = [txtFname, lblError, ["not-empty"]] as NSMutableArray
        dict[1] = [txtLname, lblError, ["not-empty"]] as NSMutableArray
        dict[2] = [txtEmail, lblError, ["not-empty", "email"] ] as NSMutableArray
        
        
        
        
        
        let validator = Validator()
        
        if(validator.validate(dict)) {
            
            
            SwiftSpinner.show("Updating...").addTapHandler({
                SwiftSpinner.hide()
            })
            
            Alamofire.request(
                .POST,
                API_Domain + "/api/user",
                parameters: ["email": txtEmail.text!, "fname": txtFname.text!,"lname": txtLname.text!, "phone": txtPhone.text!,"city": txtCity.text!, "bio":txtBio.text!, "uid":uid],
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    guard response.result.isSuccess else {
                        SwiftSpinner.hide()
                        
                        self.lblError.text = "This email is associated with another account"

                        
                        return
                    }
                    
                    SwiftSpinner.hide({
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                    //let res = JSON(response.result.value!)
                    
                    
                    
                    
                    
            }
            
        }
        
    }
    
    
    
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //    print(pickerData.count)
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // print(row)
    }
    
}
