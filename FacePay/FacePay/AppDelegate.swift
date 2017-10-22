//
//  AppDelegate.swift
//  FacePay
//
//  Created by Bruce Brookshire on 10/20/17.
//  Copyright © 2017 VandyHacks. All rights reserved.
//

import AWSCore
import AWSCognito
import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: "us-east-1:106931b0-67c5-4655-b747-dcb92a5e81ec")
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        FPVariablesManager.sharedInstance.window = UIWindow(frame: UIScreen.main.bounds)
        let window = FPVariablesManager.sharedInstance.window!
        
        var VC: UIViewController?
        
        let defaults = UserDefaults.standard
        
        if let accountKey = defaults.object(forKey: DefaultsKeys.accountSecret) as? String{
            let currentUser = CurrentUser(accountID: accountKey, balance: 0.0)
            FPVariablesManager.sharedInstance.currentUser = currentUser
            VC = FPHomeViewController(nibName: XIBFiles.HOMEVIEW, bundle: nil)
        } else {
            VC = FPDisambiguationController(nibName: XIBFiles.DISAMBIGUATIONVIEW, bundle: nil)
        }
        
        let navController = FPNavigationController(rootViewController: VC!)
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

