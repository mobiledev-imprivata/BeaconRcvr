//
//  AppDelegate.swift
//  BeaconRcvr
//
//  Created by Jay Tucker on 4/5/16.
//  Copyright © 2016 Imprivata. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var beaconManager: BeaconManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        log("application didFinishLaunchingWithOptions")
        
        if let launchOptions = launchOptions, launchOptions[UIApplicationLaunchOptionsKey.location] != nil {
            log("app launched in response to a CoreLocation event")
            showNotification("app launched in response to a CoreLocation event")
        }

        // Override point for customization after application launch.
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: .alert, categories: nil))
        
        beaconManager = BeaconManager()
        beaconManager.delegate = self
        beaconManager.startMonitoring()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        log("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        log("applicationDidEnterBackground")
        
        // beaconManager.startMonitoring()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        log("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        log("applicationDidBecomeActive")

        // beaconManager.startMonitoring()
        // beaconManager.stopMonitoring()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        log("applicationWillTerminate")
        
        // beaconManager.startMonitoring()
    }

}

extension AppDelegate: BeaconManagerDelegate {

    func showNotification(_ message: String) {
        let notification = UILocalNotification()
        notification.alertBody = message
        UIApplication.shared.presentLocalNotificationNow(notification)
    }
    
}

