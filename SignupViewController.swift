
import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import KeychainSwift
class SignupViewController: UIViewController {
    
    
    let keychain = KeychainSwift()
    
    @IBOutlet var lblError1: UILabel!
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var lblError2: UILabel!
    @IBOutlet var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        
        var dict = Dictionary<Int, NSMutableArray>()
        dict[0] = [txtEmail, lblError1, ["not-empty","email"]] as NSMutableArray
        dict[1] = [txtPassword, lblError2, ["not-empty"]] as NSMutableArray
        
        let validator = Validator()
        
        if(validator.validate(dict)) {
            
            
            SwiftSpinner.show("Updating...").addTapHandler({
                SwiftSpinner.hide()
            })
            
            Alamofire.request(
                .POST,
                API_Domain + "/api/user",
                parameters: ["email": txtEmail.text!, "password": txtPassword.text!],
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    SwiftSpinner.hide()
                    guard response.result.isSuccess else {
                        SwiftSpinner.hide()
                        
                        self.lblError1.text = "Email already exists!"
                        
                        
                        return
                    }
                    
                    let res = JSON(response.result.value!)
                    
                    
                    
                    let uid = res["uid"].stringValue
     
                  
                        self.keychain.set(uid, forKey:
                            "HB_uid")
                        self.keychain.set("yes", forKey:
                        "HB_monitor_location_once")
                     self.navigationController?.popToRootViewControllerAnimated(true)
                      
                    
                    
                    
                    
                    
                    
            }
            
        }
        
    }
    
    
    
}

