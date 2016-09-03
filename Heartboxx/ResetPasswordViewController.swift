import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet var txtEmail: UITextField!
    
    
    @IBOutlet var lblError: UILabel!
  
    override func viewDidLoad() {
        self.hideKeyboardWhenSingleTappedAround()

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

        
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
                //    print(response.result)
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
    
    func keyboardWillShow(notification: NSNotification) {
        
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += 100
            }
            else {
                
            }
        }
    }
    
    
    
}

