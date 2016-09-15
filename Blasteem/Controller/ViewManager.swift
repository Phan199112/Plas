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
            if let current_user_id = USER_DEFAULTS.objectForKey(Current_User_ID) as? Int{
                AppSetting.current_user_id = current_user_id
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
        for key in Array(NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys) {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }

        setRootVC()
    }
    
    func popToMainPage() {
        
        while !(rootNavVC?.visibleViewController?.isKindOfClass(SWRevealViewController.self))! {
            rootNavVC?.popViewControllerAnimated(false)
        }
        
    }
    func showVideoPage(video:VideoModel,homeVC:HomeViewController?,creatorVC:CreatorDetailTableViewController?) {
        let videoVC = storyBoard.instantiateViewControllerWithIdentifier("VideoDetailViewController") as? VideoDetailViewController
        videoVC?.video = video
        videoVC?.homeVC = homeVC
        videoVC?.creatorVC = creatorVC
        rootNavVC?.pushViewController(videoVC!, animated: true)
    }
    
    func showWebPage(video_url:String,title:String)  {
        let webPage = self.storyBoard.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        webPage.post_title = title
        webPage.url = video_url
        rootNavVC?.pushViewController(webPage, animated: false)
    }
    
    func showUpdateProfilePage(user:UserModel) {
        let updateProfileVC = storyBoard.instantiateViewControllerWithIdentifier("UpdateProfileHomeViewController") as? UpdateProfileHomeViewController
        updateProfileVC?.currentUser = user
        rootNavVC?.pushViewController(updateProfileVC!, animated: true)
    }
    
    func showResetPasswordPage() {
        let resetVC = storyBoard.instantiateViewControllerWithIdentifier("ResetPasswordViewController") as? ResetPasswordViewController
        
        rootNavVC?.pushViewController(resetVC!, animated: true)
    }
    
}
