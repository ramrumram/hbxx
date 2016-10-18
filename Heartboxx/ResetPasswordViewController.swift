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
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
    }
    
    
    
    
    @IBAction func btnSave(_ sender: AnyObject) {
        
        
        var dict = Dictionary<Int, NSMutableArray>()
        dict[0] = [txtEmail, lblError, ["not-empty"]] as NSMutableArray
        
        
        
        
        
        let validator = Validator()
        
        if(validator.validate(dict)) {
            
            
            SwiftSpinner.show("Please wait...").addTapHandler({
                SwiftSpinner.hide()
            })
            
            Alamofire.request(
                API_Domain + "/api/forgot",
                method: .post,

                parameters: ["email": txtEmail.text!],
                                encoding: URLEncoding.default)
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
    
    func keyboardWillShow(_ notification: Notification) {
        
        if (((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= 100
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if (((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += 100
            }
            else {
                
            }
        }
    }
    
    
    
}

