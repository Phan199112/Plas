//
//  ViewManager.swift
//  Blasteem
//
//  Created by k on 8/20/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class ViewManager: NSObject {
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var window:UIWindow?
    
    var rootNavVC:RootNavViewController?
    var mainVC : SWRevealViewController?
    var loginVC : LoginViewController?
    class var sharedInstance: ViewManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ViewManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ViewManager()
        }
        return Static.instance!
    }
    
    override init() {
        
        mainVC = storyBoard.instantiateViewControllerWithIdentifier("SWRevealViewController") as? SWRevealViewController
        loginVC = storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
    }
    
    func setRootVC() {
        
        if USER_DEFAULTS.boolForKey(IS_LOGIN) {
            rootNavVC = RootNavViewController(rootViewController: mainVC!)
            if let decoded:NSData = USER_DEFAULTS.objectForKey(Current_User) as? NSData {
                let user = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? UserModel
                AppSetting.currentUser = user
            }
        }else{
            rootNavVC = RootNavViewController(rootViewController: loginVC!)
            
        }
        window?.rootViewController = rootNavVC
    }
    
    func showHomePage()  {
        rootNavVC!.pushViewController(mainVC!, animated: false)
    }
    
    func showLoginPage() {
        USER_DEFAULTS.setBool(false, forKey: IS_LOGIN)
        setRootVC()
    }

}
