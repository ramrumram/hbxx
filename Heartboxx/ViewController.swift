//
//  ViewController.swift
//  Heartboxx
//
//  Created by dev on 4/21/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import CoreLocation




class ViewController: UIViewController,CLLocationManagerDelegate {

    
    @IBOutlet var txtSearch: UITextField!
     let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        
        
        txtSearch.layer.borderWidth = 1
        txtSearch.layer.borderColor = UIColor.blackColor().CGColor
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
      //  print ("sdds")
       // self.navigationItem.setHidesBackButton(false, animated:false);

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //check the location is authorized..all the funcatioalities shoud go through this

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

