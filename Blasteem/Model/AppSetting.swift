//
//  AppSetting.swift
//  Blasteem
//
//  Created by k on 8/20/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class AppSetting: NSObject {
    static var isHome:Bool = false
    static var isViews:Bool = false
    static var isCategories:Bool = false
    static var isNotifications:Bool = false
    
    class func setIsHome()
    {
        isHome = true
        isViews = false
        isCategories = false
        isNotifications = false
    }
    
    class func setIsViews()
    {
        isHome = false
        isViews = true
        isCategories = false
        isNotifications = false
    }
    class func setIsCategories()
    {
        isHome = false
        isViews = false
        isCategories = true
        isNotifications = false
    }
    class func setIsNotification()
    {
        isHome = false
        isViews = false
        isCategories = false
        isNotifications = true
    }
    
    class func setNone()
    {
        isHome = false
        isViews = false
        isCategories = false
        isNotifications = false
    }
    
    static var currentUser:UserModel?
    static var current_user_id:Int?
    static var current_user_password:String?
    static var device_token:String?
    static var notification_arr:[VideoModel] = []
}
