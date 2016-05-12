import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import CoreLocation

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate  {
    
    @IBOutlet var stackTemp: UIStackView!
    @IBOutlet var imgTemp: UIImageView!
    @IBOutlet var lblTemp: UILabel!
    
    @IBOutlet var stackTable: UIStackView!
    @IBOutlet var txtSearch: UITextField!
    let locationManager = CLLocationManager()
    
    @IBOutlet var tableView: UITableView!
    //var visits = [String : AnyObject]()
    var places = Dictionary<Int, NSMutableArray>()
    let blogSegueIdentifier = "ShowPlaceSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        btnSearchVenue(txtSearch)
        
        
        tableView.tableFooterView = UIView()
        
        // Load the sample data.
        // loadHistory()
    }
    
    
    
    @IBAction func btnSearchVenue(sender: AnyObject) {
        
        var q =  (txtSearch.text)!
        
        if(q.characters.count > 2) {
             var ll = ""
            
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
                            var tvenueid = ""
                            var timage = ""
                            var tid = ""
                            
                            
                            if let vid = venues[i]["id"].string{
                                tid = vid
                            }
                            if let name = venues[i]["name"].string{
                                tname = name
                            }
                            
                            if let address =  venues[i]["location"]["formattedAddress"].array {
                                tcatname = address.minimalDescrption
                                
                        
                            }
                          
                           if let vid = venues[i]["id"].string{
                                tvenueid = vid
                            }
                            
                            if let pf = venues[i]["categories"][0]["icon"]["prefix"].string, sf = venues[i]["categories"][0]["icon"]["suffix"].string {
                                timage = pf + "bg_32" + sf
                            }
                            
                            
                            
                            self.places [i] = [tname, tcatname, timage, tid]
                            
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
    
   
    

    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            //       print(".NotDetermined")
            locationManager.requestAlwaysAuthorization()
            break
            
        case .Authorized:
            //   print(".Authorized")
            locationManager.startMonitoringSignificantLocationChanges()
            //    locationManager.startUpdatingLocation()
            
            break
            
        case .Denied, .Restricted:
           
            promptAccess()
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
        // mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last! as CLLocation
              
        
        let tmp = String(location.coordinate)
        
        let common = Common();
        common.postLog(tmp)
        
        
        
    }
    
    func promptAccess() {
        let alertController = UIAlertController(
            title: "Background Location Access Disabled",
            message: "In order to be notified about location changes, please open this app's settings and set location access to 'Always'.",
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
