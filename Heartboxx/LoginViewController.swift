//
//  LoginViewController.swift
//  Heartboxx
//
//  Created by dev on 5/9/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import KeychainSwift
import Alamofire
import SwiftSpinner
import SwiftyJSON
import CoreLocation


class LoginViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var txtPassword: UITextField!
    
    @IBOutlet var lblError: UILabel!
    
    
    @IBOutlet var lblError1: UILabel!
    
    let keychain = KeychainSwift()
    
    let Fields = ["Email", "Password"]
    
    let locationManager = CLLocationManager()
    
    let common = Common()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
    }
    
    @IBAction func login(sender: AnyObject) {
        
        
        self.dismissKeyboard()
        var dict = Dictionary<Int, NSMutableArray>()
        dict[0] = [txtEmail, lblError, ["not-empty", "email"] ] as NSMutableArray
        dict[1] = [txtPassword, lblError1, ["not-empty"]] as NSMutableArray
        
        
        
        let validator = Validator()
        
        if(validator.validate(dict)) {
            
            
            SwiftSpinner.show("Aunthenticating...")
            
            Alamofire.request(
                .POST,
                API_Domain + "/api/login",
                parameters: ["email": txtEmail.text!, "password": txtPassword.text!],
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    SwiftSpinner.hide()
                    guard response.result.isSuccess else {
                        self.lblError.text = "Invalid credentials"
                             print("Error connecting remote: \(response.result.error)")
                        //  completion(nil)
                        return
                    }
                    let res = JSON(response.result.value!)
                    if let uid = res["uid"].string, bkstatus = res["background_status"].string  {
                        self.keychain.set(uid, forKey: "HB_uid")
                        
                       
                        if (bkstatus == "1") {
                            self.locationManager.startMonitoringSignificantLocationChanges()
                        }else {
                            //stop the location update started when the app ran for the first time
                            self.locationManager.stopMonitoringSignificantLocationChanges()
                        }
                        
                        self.goToHome()
                    }
                    
                    
                    
                    
            }
            
        }
        
        
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        //   blogNameLabel.text = blogName
        
        //will try going to homeviewcontroller
        goToHome()
    }
    
    func goToHome() {
        //check if already logged in
        
        if (keychain.get("HB_uid") != nil) {

            // just after signing up, need to fire this up,because signficationlocation update has already fired in without any db updates
            if(keychain.get("HB_monitor_location_once") != nil) {

                let authstate = CLLocationManager.authorizationStatus()
                if(authstate == CLAuthorizationStatus.AuthorizedAlways){
                    print ("coming mach")
                    keychain.delete("HB_monitor_location_once")
                    //just one time..stop it immediately to save battery power
                  //  locationManager.stopUpdatingLocation()
                  //  locationManager.startUpdatingLocation()
                    
                }
            }
            let storyboard = UIStoryboard(name: "User", bundle: nil)
            
            let rootController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController")
            
            self.navigationController?.pushViewController(rootController, animated: true)
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            print(".NotDetermined")
            locationManager.requestAlwaysAuthorization()
            break
            
        case .Authorized:
            print(".Authorized")
            
            locationManager.startMonitoringSignificantLocationChanges()
            
            //locationManager.startUpdatingLocation()
            
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
    
    
    func stopBackgroud() {
        //locationManager.allowsBackgroundLocationUpdates = false
        
        common.saveBckStatus("0")
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    func startBackgroud() {
       // locationManager.allowsBackgroundLocationUpdates = true
        common.saveBckStatus("1")
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        let location = locations.last! as CLLocation
        let numlat = NSNumber(double: (location.coordinate.latitude) as Double)
        let la:String = numlat.stringValue
        let numlo = NSNumber(double: (location.coordinate.longitude) as Double)
        let lo:String = numlo.stringValue
        
        let ll = la+","+lo
        
        if (keychain.get("HB_uid") != nil) {
            
            
            let uid = keychain.get("HB_uid")!
            Alamofire.request(
                .POST,
                API_Domain + "/api/venues/history",
                parameters: ["uid": uid, "ll": ll],
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    guard response.result.isSuccess else {
                        print("Error connecting remote: \(response.result.error)")
                        //  completion(nil)
                        return
                    }
                    //         let res = JSON(response.result.value!)
                    
                    
                    
                    
            }
            //  let common = Common();
            //   common.postLog(ll+uid)
            
            //  print (ll)
            // print ("dd")
            
            //print(location.coordinate)
            
            
            // let tmp = String(location.coordinate)
            
            
        }
        
        
    }
    
}
