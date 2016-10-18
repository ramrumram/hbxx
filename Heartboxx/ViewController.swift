
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
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.hideKeyboardWhenTappedAround()
        
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()

        
        
       
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //  print ("sdds")
        // self.navigationItem.setHidesBackButton(false, animated:false);
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //check the location is authorized..all the funcatioalities shoud go through this
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
                  print(".NotDetermined")
            locationManager.requestAlwaysAuthorization()
            break
            
        case .authorizedAlways:
               print(".Authorized")
            //locationManager.startMonitoringSignificantLocationChanges()
                locationManager.startUpdatingLocation()
            
            break
            
        case .denied, .restricted:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about location changes, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
        // mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last! as CLLocation
         print ("sdsd")
        
        print(location.coordinate)
        
        
      //  let tmp = String(location.coordinate)
        
     //   let common = Common();
     //   common.postLog(tmp)
        
        
        
    }
    
    
    
    
}

