//
//  AppDelegate.swift
//  Heartboxx
//
//  Created by dev on 4/21/16.
//  Copyright © 2016 heartboxx. All rights reserved.
//

import UIKit
import KeychainSwift
import FacebookCore


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var common = Common()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 

       
        registerForPushNotifications(application)
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        
        return true
    }

    //local notifcation handler
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            
            notificationPlaceObj = userInfo as NSDictionary
            
           
           // application.cancelLocalNotification(notification)
            let navigationController = application.windows[0].rootViewController as! UINavigationController

            let mainStoryboard: UIStoryboard = UIStoryboard(name: "User", bundle: nil)
            
            navigationController.pushViewController(mainStoryboard.instantiateViewController(withIdentifier: "PlaceDetailViewController") as UIViewController, animated: true)

            
          
     
        }
    }
    

 
 
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Call the 'activate' method to log an app event for use
        // in analytics and advertising reporting.
        AppEventsLogger.activate(application)
        // ...
    }
    
    func registerForPushNotifications(_ application: UIApplication) {
        
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            //application.registerForRemoteNotifications()
            
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        device_id = tokenString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
   
}

