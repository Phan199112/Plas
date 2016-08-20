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
//        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.show()
    }
    
    class func showErrorMessage(message:String)
    {
        ProgressHUD.showError(message)
//        SVProgressHUD.showImage(UIImage(named: "close_button"), status: message)
    }
    
    class func showSuccess(message:String)
    {
        ProgressHUD.showSuccess(message)
    }
    
    class func disappearLoadingHud() {
        SVProgressHUD.dismiss()
    }
}