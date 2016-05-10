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
        
        
        
       // txtSearch.layer.borderWidth = 1
       // txtSearch.layer.borderColor = UIColor.blackColor().CGColor
        
        let imageView = UIImageView();
        let image = UIImage(named: "logo.png");
        imageView.image = image;
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.addSubview(imageView)
        
        txtSearch.leftView = imageView;
        txtSearch.leftViewMode = UITextFieldViewMode.Always
        
        
        // Load the sample data.
       // loadHistory()
    }
    
    
    
    @IBAction func btnSearchVenue(sender: AnyObject) {
        
        //print ("hii")
        let q =  (txtSearch.text)!
        if(q.characters.count > 2) {
            stackTemp.hidden=true
            stackTable.hidden=false
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let v = dateFormatter.stringFromDate(NSDate())
            
            let ll = "8.720277777777778,77.65583333333333"
            let url =  "https://api.foursquare.com//v2/venues/search?ll="+ll+"&query="+q+"&client_id=MNGNKO0QUJK2534VZKPGF5YD1NUW0AZM0F1YFJHIANYBAVJH&client_secret=2TIP4IONOYKBBTPYA1FGFARLY0JCVDCJIK3L1RG1N2NPJ21E&limit=5&v="+v
            
            
            
            
            
            Alamofire.request(
                .GET,
                url,
                
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    guard response.result.isSuccess else {
                        print("Error while fetching remote rooms: \(response.result.error)")
                        //  completion(nil)
                        return
                    }
                    let res = JSON(response.result.value!)
                    let venues = res["response"]["venues"]
                    
                    
                    var i = 0
                    while i < venues.count {
                        var tname = ""
                        var tcatname = ""
                        if let name = venues[i]["name"].string{
                            tname = name
                        }
                        if let catname = venues[i]["categories"][0]["shortName"].string {
                            tcatname = catname
                        }
                        self.places [i] = [tname, tcatname]
                        
                        https://api.foursquare.com/v2/venues/
                        
                        i = i+1
                    }
                    
                    
                    self.tableView.reloadData()
                    
                   // print (places)
                    //  if let venues = res["response"].string {
                    //       print(venues)
                    //
                    //  }
                    
                    
                    //   rows["data"] =  res["history"]
                    
                    /*  guard let value = response.result.value as? [String: AnyObject] else {
                     return
                     }
                     
                     
                     */
                    
                    
                    
                    
                    
                    
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

    
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.places.count;
       
    }
    
 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SearchTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SearchTableViewCell
        
        
        
        //temphistory[0]
        let visit = self.places[indexPath.row]!
        
        
        
        cell.lblShopName.text = visit[0] as? String
        let imgurl =  visit[2] as? String
        //   print(imgurl)
        let URL = NSURL(string: imgurl!)!
        let placeholderImage = UIImage(named: "logo")!
        
        cell.imgHistory.af_setImageWithURL(URL, placeholderImage: placeholderImage)
        
        // cell.imgHistory.image = visit["cat_img"] as? String
        cell.lblCategory.text = visit[1] as? String
        
        return cell
    }
    
    
    
    
    
    
    let blogSegueIdentifier = "ShowNewMessage"
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let button = sender as? UIButton {
            let cell = button.superview?.superview as! UITableViewCell
            let destination = segue.destinationViewController as? NewMessageController,
            indexPath = self.tableView.indexPathForCell(cell)!
            let temphistory = visits["history"] as! [NSArray]
            
            
            //temphistory[0]
            let visit = temphistory[indexPath.section][indexPath.row]
            
            //  print((visit["venue_name"] as? String)!)
            destination!.venueName = (visit["venue_name"] as? String)!
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
        // print ("sdsd")
        
        //print(location.coordinate)
        
        
        let tmp = String(location.coordinate)
        
        let common = Common();
        common.postLog(tmp)
        
        
        
    }
}
