import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet var txtEmail: UITextField!
    
    
    @IBOutlet var lblError: UILabel!
  
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    
    
    @IBAction func btnSave(sender: AnyObject) {
        
        
        var dict = Dictionary<Int, NSMutableArray>()
        dict[0] = [txtEmail, lblError, ["not-empty"]] as NSMutableArray
        
        
        
        
        
        let validator = Validator()
        
        if(validator.validate(dict)) {
            
            
            SwiftSpinner.show("Please wait...").addTapHandler({
                SwiftSpinner.hide()
            })
            
            Alamofire.request(
                .POST,
                API_Domain + "/api/forgot",
                parameters: ["email": txtEmail.text!],
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    guard response.result.isSuccess else {
                        SwiftSpinner.hide()
                        
                        self.lblError.text = "System error!"
                        
                        
                        return
                    }
                    SwiftSpinner.hide()

                    let res = JSON(response.result.value!)
                    
                    if let val =  res["status"].string {
                        self.lblError.text = val
                    }
                    
                    //
                    
                    
                    
                    
                    
                    
            }
            
        }
        
    }
    
    
    
}

