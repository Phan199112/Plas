//
//  AppDelegate.swift
//  Blasteem
//
//  Created by k on 8/17/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,DSRestClientDelegate {

    var window: UIWindow?
    var restClient:DSRestClient?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //FaceBook Signin
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        //Google Signin
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        ViewManager.sharedInstance.window = self.window
        ViewManager.sharedInstance.setRootVC()
        
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        self.restClient = DSRestClient(key: AppCredential.CLIENT_ID, andSecret: AppCredential.CLIENT_SECRET)
        self.restClient?.delegate = self
        
        self.restClient?.registerWithUrl(ApiUrl.BASEURL + "pnfw/register/", andToken: deviceToken)
        
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString( " ", withString: "") as String
        USER_DEFAULTS.setObject(deviceTokenString, forKey: "device_token")
        
        
    }
    
    func restClientRegistered(client: DSRestClient!) {
        
    }
    
    func restClient(client: DSRestClient!, registerFailedWithError error: NSError!) {
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if !USER_DEFAULTS.boolForKey(IS_LOGIN) {
            USER_DEFAULTS.setObject(nil, forKey: "isforeground")
            USER_DEFAULTS.setObject(nil, forKey: "video_id")
            return
        }
      
        if application.applicationState == UIApplicationState.Active
        {
            
            USER_DEFAULTS.setObject("yes", forKey: "isforeground")
            
            
        }else{
            USER_DEFAULTS.setObject("no", forKey: "isforeground")
            USER_DEFAULTS.setObject(userInfo["id"] as! String, forKey: "video_id")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("RemoteNotification", object: nil)
        
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handleURL(url,
                                                                                                                                                                                                      sourceApplication: sourceApplication,
                                                                                                                                                                                                      annotation: annotation)
    }
    
//    func application(application: UIApplication,
//                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
//        return GIDSignIn.sharedInstance().handleURL(url,
//                                                    sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
//                                                    annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
//    }
    
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

