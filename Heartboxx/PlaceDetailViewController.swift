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


class PlaceDetailViewController: UIViewController {
    
    @IBOutlet var lblPlaceName: UILabel!
    
    @IBOutlet var imgPlace: UIImageView!
    
    @IBOutlet var lblAddress: UILabel!
    var venueName = NSMutableArray()
    
    @IBOutlet var stackMainImg: UIStackView!
    
    
    let blogSegueIdentifier = "ShowNewMessage"
    @IBOutlet var stackLogo: UIStackView!
    override func viewDidLoad() {
        
        stackMainImg.hidden = true
        stackLogo.hidden = false
    }
    override func viewWillAppear(animated: Bool) {
        //print (venueName)
        //   blogNameLabel.text = blogName
       var vid = venueName[3] as! String
       let dateFormatter = NSDateFormatter()
       dateFormatter.dateFormat = "yyyyMMdd"
       let v = dateFormatter.stringFromDate(NSDate())

        
    
        lblPlaceName.text = (venueName[0] as? String)!
        lblAddress.text = (venueName[1] as? String)!
        
       
        
        
        
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
                    self.stackMainImg.hidden = false
                    self.stackLogo.hidden = true
                    if let sf = photos["items"][0]["suffix"].string, pf = photos["items"][0]["prefix"].string  {
                        
                        timage =  pf + "400x200" +  sf
                    //    print(i)
                        
                        let imgurl =  timage
                        //   print(imgurl)
                        let URL = NSURL(string: imgurl)!
                        let placeholderImage = UIImage(named: "badge")!
                        self.imgPlace.af_setImageWithURL(URL, placeholderImage: placeholderImage)
                    }
                    
                    
                }
                
                
                
        }

        
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if  segue.identifier == blogSegueIdentifier{
            let destination = segue.destinationViewController as? NewMessageController
            
            
            //temphistory[0]
            
            //  print((visit["venue_name"] as? String)!)
            destination!.venueName = (venueName[0] as? String)!
            destination!.address = (venueName[1] as? String)!
            
            //  print(indexPath.length)
            
        }
        
    }
    
    
    

}
