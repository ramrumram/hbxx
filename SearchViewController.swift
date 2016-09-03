import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import CoreLocation
import KeychainSwift

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet var lblTemp: UILabel!
    
    @IBOutlet var lblQuote: UILabel!
    @IBOutlet var stackTable: UIStackView!
    @IBOutlet var stackTemp: UIStackView!
    @IBOutlet var txtSearch: UITextField!
    let locationManager = CLLocationManager()
    
    @IBOutlet var btnSug: UIButton!
    
    @IBOutlet var tableView: UITableView!
    //var visits = [String : AnyObject]()
    var places = Dictionary<Int, NSMutableArray>()
    let blogSegueIdentifier = "ShowPlaceSegue"
    
  
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        let keychain = KeychainSwift()

        if (keychain.get("HB_sgcnt") != nil) {

             btnSug.setTitle(keychain.get("HB_sgcnt")!, forState: .Normal)
        }
        
        //let labelHgt = UIScreen.mainScreen().bounds.height * 0.25
        lblTemp.numberOfLines = 15
        

        tableView.delegate = self
        tableView.dataSource = self
        
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        
 
        
        
        tableView.tableFooterView = UIView()
        
      
    }
    
    func animateQuote (i: Int) {
        
        
        
        // Fade in the view
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.lblQuote.alpha = 1
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animateWithDuration(3.0, delay: 3, options: [.CurveEaseInOut], animations: { () -> Void in
                self.lblQuote.alpha = 0
                
                //assign random quote
                
                
                
                
                },
                                       completion:  {finished in
                if finished {
                    
                    var quotes:[String] = ["\"I want to see this neighbourhood thrive.\"", "\"If only the lights were dimmed down a bit more.\"", "\"I want them to succeed.\""]
                    
                    
                      self.lblQuote.text = quotes[i%3]

                self.animateQuote(i + 1)
            }
        })
    }
    }
 
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
    
        
        
        self.animateQuote(0)
        
        

    }
    
    
    
    
    
    @IBAction func searchEditBegan(sender: AnyObject) {
        
        lblTemp.text=""
    }
    
    @IBAction func btnSearchVenue(sender: AnyObject) {
        
        
    
        
        
        var q =  (txtSearch.text)!
        
        if(q.characters.count > 2) {
            self.dismissKeyboard()
             var ll = ""
            locationManager.requestWhenInUseAuthorization()
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways)
            {
                let numlat = NSNumber(double: (locationManager.location?.coordinate.latitude)! as Double)
                let la:String = numlat.stringValue
                let numlo = NSNumber(double: (locationManager.location?.coordinate.longitude)! as Double)
                let lo:String = numlo.stringValue
                
                 ll = la+","+lo
                
            } else {
                promptAccess()
                return
            }
            
            
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            q = q.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
           
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let v = dateFormatter.stringFromDate(NSDate())
           
            
            let url =  "https://api.foursquare.com/v2/venues/search?ll="+ll+"&query="+q+"&client_id=MNGNKO0QUJK2534VZKPGF5YD1NUW0AZM0F1YFJHIANYBAVJH&client_secret=2TIP4IONOYKBBTPYA1FGFARLY0JCVDCJIK3L1RG1N2NPJ21E&limit=4&v="+v
            
            
            Alamofire.request(
                .GET,
                url,
                
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    guard response.result.isSuccess else {
                        print("Error while fetching remote rooms: \(response.result.error)")
                        //  completion(nil)
                        return
                    }
                    let res = JSON(response.result.value!)
                    let venues = res["response"]["venues"]
                    
                    
                    if venues.count > 0 {
                        self.stackTemp.hidden=true
                        self.stackTable.hidden=false
                        var i = 0
                        while i < venues.count {
                            
                            var tname = ""
                            var tcatname = ""
                            var timage = ""
                            var tid = ""
                            var smallAddr = ""
                            var st = ""
                            
                            
                            if let vid = venues[i]["id"].string{
                                tid = vid
                            }
                            if let name = venues[i]["name"].string{
                                tname = name
                            }
                            
                            
                            
                          
                            if let address =  venues[i]["location"]["formattedAddress"].array {
                                tcatname = address.minimalDescrption
                                
                        
                            }
                          
                      
                            
                            if let pf = venues[i]["categories"][0]["icon"]["prefix"].string, sf = venues[i]["categories"][0]["icon"]["suffix"].string {
                                timage = pf + "bg_32" + sf
                            }
                            
                            if let name = venues[i]["location"]["address"].string,s = venues[i]["location"]["crossStreet"].string {
                                smallAddr = name
                                st = s
                            }
                            
                            self.places [i] = [tname, tcatname, timage, tid, smallAddr, st]
                            
                            i = i+1
                            
                        }
                        self.tableView.reloadData()
                        
                    }else {
                        self.lblTemp.text = "Sorry! No records found"
                        //no venu found
                        self.stackTemp.hidden=false
                        self.stackTable.hidden=true
                    }
                    
            }
            
            
        } else {
            stackTemp.hidden=false
            stackTable.hidden=true
        }
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.places.count;
        
    }
    
    
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SearchTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchTableViewCell
        
        //temphistory[0]
        let visit = self.places[indexPath.row]!
     //   print (visit)
        var shopstr = (visit[0] as? String)! + " " + (visit[1] as? String)!
        shopstr = shopstr.trunc(30)
        cell.lblShopName.text = shopstr
        let imgurl =  visit[2] as? String
        //   print(imgurl)
        let URL = NSURL(string: imgurl!)!
        let placeholderImage = UIImage(named: "badge")!
        
        cell.imgHistory.af_setImageWithURL(URL, placeholderImage: placeholderImage)
        
        
        
        return cell
    }
    
  
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        self.dismissKeyboard()
       if  segue.identifier == blogSegueIdentifier{
            let destination = segue.destinationViewController as? PlaceDetailViewController,
            indexPath = self.tableView.indexPathForSelectedRow?.row
            let temphistory = self.places
            
            
            //temphistory[0]
            let visit = temphistory[indexPath!]
            
            //  print((visit["venue_name"] as? String)!)
            destination!.venueName = visit! 
            //  print(indexPath.length)
            
        }
        
    }
    
     
    
 
    
    func promptAccess() {
        let alertController = UIAlertController(
            title: "Location Access Disabled",
            message: "In order to get your current location, please open this app's settings and set location access to 'Always' or 'While Using the App'.",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
