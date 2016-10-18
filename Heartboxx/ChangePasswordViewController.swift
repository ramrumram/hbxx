

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import KeychainSwift
class ChangePasswordViewController: UITableViewController {
   
    
    let keychain = KeychainSwift()
   
    @IBOutlet var lblError1: UILabel!
    @IBOutlet var txtCpassword: UITextField!
    
    @IBOutlet var lblError2: UILabel!
    @IBOutlet var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()

        
    }
    
    
    
    
    @IBAction func btnSave(_ sender: AnyObject) {
        
        let uid = keychain.get("HB_uid")!
        
        var dict = Dictionary<Int, NSMutableArray>()
        dict[0] = [txtCpassword, lblError1, ["not-empty"]] as NSMutableArray
        dict[1] = [txtPassword, lblError2, ["not-empty"]] as NSMutableArray
      
        
        
        
        
        
        let validator = Validator()
        
        if(validator.validate(dict)) {
            
            
            SwiftSpinner.show("Updating...").addTapHandler({
                SwiftSpinner.hide()
            })
            
            Alamofire.request(
                
                API_Domain + "/api/password",
                  method: .post,
                parameters: ["cpassword": txtCpassword.text!, "password": txtPassword.text!, "uid":uid],
                encoding: URLEncoding.default)
                .validate()
                .responseJSON { (response) -> Void in
                    guard response.result.isSuccess else {
                        SwiftSpinner.hide()
                        
                        self.lblError1.text = "Wrong current password"
                        
                        
                        return
                    }
                    
                    SwiftSpinner.hide({
                        self.navigationController?.popViewController(animated: true)
                    })
                    //let res = JSON(response.result.value!)
                    
                    
                    
                    
                    
                    
            }
            
        }
        
    }
    
    
    
}

