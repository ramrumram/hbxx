//
//  AppDelegate.swift
//  Heartboxx
//
//  Created by dev on 4/21/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import CoreLocation
import KeychainSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager() // Add this statement
    var common = Common()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
 
        
        print ("deel")
        //for handling local notification
        if let options = launchOptions {
            if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
                print ("hellow ohooo")
                if let userInfo = notification.userInfo {
                    
                    notificationPlaceObj = userInfo as NSDictionary
                    
                    
                    
                    
                    
                    // do something neat here
                }
            }
        }
        
        
        // Override point for customization after application launch.
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
       
        registerForPushNotifications(application)
        
       
            
        return true
    }

    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            notificationPlaceObj = userInfo as NSDictionary
            
            print ("sllsyw here")
         //   let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "User", bundle: nil)
         //   let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("PlaceDetailViewController") as UIViewController
         //   self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //    self.window?.rootViewController = initialViewControlleripad
        //    self.window?.makeKeyAndVisible()

            
            
           // print ("sllsyw here")
           // print(userInfo)
           
            //  print((visit["venue_name"] as? String)!)
//            destination!.venueName = visit!

             //   let storyboard = UIStoryboard(name: "User", bundle: nil)
              //   let vc = storyboard.instantiateViewControllerWithIdentifier("PlaceDetailViewController") as! UIViewController
               //  vc.venueName = visit!
            
        //    let viewController = PlaceDetailViewController()
        //    viewController.venueName = visit
         //   self.navigationController?.presentViewController(viewController, animated: true, completion: nil)
            
           
       
            //   self.presentViewController(viewController, animated: true, completion: nil)
           // print("didReceiveLocalNotification: \(customField1)")
        }
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
     //  common.postLog("coming baby")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       // common.postLog("entienr back baby")
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            //application.registerForRemoteNotifications()
            
        }
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        device_id = tokenString
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
   
}

