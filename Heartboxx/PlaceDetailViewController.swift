//
//  PlaceDetailViewController.swift
//  Heartboxx
//
//  Created by dev on 5/11/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import KeychainSwift

class PlaceDetailViewController: UIViewController {
    
    @IBOutlet var lblPlaceName: UILabel!
    
    @IBOutlet var imgPlace: UIImageView!
    
    @IBOutlet var lblAddress: UILabel!
    var venueName = NSMutableArray()
    
    @IBOutlet var stackMainImg: UIStackView!
    
    
    @IBOutlet var stackPlace1: UIStackView!
    @IBOutlet var lblPlace1: UILabel!
    let blogSegueIdentifier = "ShowNewMessage"
    @IBOutlet var btnSug: UIButton!
    
    override func viewDidLoad() {
        lblPlace1.layer.borderWidth = 2.0
        lblPlace1.layer.cornerRadius = 8
        lblPlace1.layer.borderColor = UIColor(red: 241/255, green: 239/255, blue: 241/255, alpha: 1).CGColor
        
        stackPlace1.hidden = true
        stackMainImg.hidden = true
        
        let keychain = KeychainSwift()
        
        if (keychain.get("HB_sgcnt") != nil) {
            
            btnSug.setTitle(keychain.get("HB_sgcnt")!, forState: .Normal)
        }
        
        
    }
    override func viewWillAppear(animated: Bool) {

        
        
        /*
      
        //this variable will be initialized when user swiped the notificatoin
        if (notificationPlaceObj.allKeys.count > 0) {
               let place = [notificationPlaceObj["tname"]!,notificationPlaceObj["tcatname"]! ,notificationPlaceObj["timage"]! ,notificationPlaceObj["tid"]!] as NSMutableArray
            venueName = place
        }
        */
        
       let vid = venueName[3] as! String
       let dateFormatter = NSDateFormatter()
       dateFormatter.dateFormat = "yyyyMMdd"
       let v = dateFormatter.stringFromDate(NSDate())

        lblPlace1.text = " " + (venueName[0] as? String)! + " " + (venueName[4] as? String)! + " "
    
        lblPlaceName.text = (venueName[0] as? String)!
        lblAddress.text = " " + (venueName[4] as? String)! + ", " + (venueName[5] as? String)! + " "
        
        
       
        
        
        
        let iurl =  "https://api.foursquare.com/v2/venues/"+vid+"/photos?client_id=MNGNKO0QUJK2534VZKPGF5YD1NUW0AZM0F1YFJHIANYBAVJH&client_secret=2TIP4IONOYKBBTPYA1FGFARLY0JCVDCJIK3L1RG1N2NPJ21E&limit=5&limit=1&v="+v
        
        
        
        
        
        
        Alamofire.request(
            .GET,
            iurl,
            
            encoding: .URL)
            .validate()
            .responseJSON { (eresponse) -> Void in
                guard eresponse.result.isSuccess else {
                    print("Error while fetching remote rooms: \(eresponse.result.error)")
                    //  completion(nil)
                    return
                }
                let ires = JSON(eresponse.result.value!)
                
                
                let photos  = ires["response"]["photos"]
                var timage = ""
                if(photos["count"] > 0) {
                    self.stackPlace1.hidden = false
                    self.stackMainImg.hidden = false
                    
                    if let sf = photos["items"][0]["suffix"].string, pf = photos["items"][0]["prefix"].string  {
                        
                        timage =  pf + "400x200" +  sf
                    //    print(i)
                        
                        let imgurl =  timage
                        //   print(imgurl)
                        let URL = NSURL(string: imgurl)!
                        self.imgPlace.af_setImageWithURL(URL)
                    }
                    
                    
                }
                
                
                
        }

        
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if  segue.identifier == blogSegueIdentifier{
            let destination = segue.destinationViewController as? NewMessageController
            
            destination!.venueName = (venueName[0] as? String)!
            destination!.address = (venueName[1] as? String)!
            
            
        }
        
    }
    
    
    

}
