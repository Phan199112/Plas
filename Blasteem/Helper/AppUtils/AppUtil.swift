//
//  AppUtil.swift
//  Blasteem
//
//  Created by k on 8/18/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import Foundation
import ZProgressHUD
import SVProgressHUD

class AppUtil {
    
    class func showLoadingHud()
    {
//        ProgressHUD .show("", interaction: false)
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.6))
        SVProgressHUD.setForegroundColor(mainColor)
        
        SVProgressHUD.show()
    }
    
    class func showErrorMessage(message:String)
    {
        ProgressHUD.showError(message)
    }
    
    class func showSuccess(message:String)
    {
        ProgressHUD.showSuccess(message)
    }
    
    class func disappearLoadingHud() {
        SVProgressHUD.dismiss()
    }
    
    class func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}