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
import KVNProgress
class AppUtil {
    
    class func showLoadingHud()
    {
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.6))
        SVProgressHUD.setForegroundColor(mainColor)
        
        SVProgressHUD.show()
//        [KVNProgress showWithStatus:@"Loading"
//        onView:view];
        
    }
    
    class func showLoadingHudOnView(view:UIView) {
        
        let configuration:KVNProgressConfiguration = KVNProgressConfiguration()
        configuration.circleStrokeForegroundColor = UIColor.whiteColor()
        
        
        configuration.backgroundFillColor = UIColor.blackColor()
        configuration.circleSize = 60.0
        configuration.lineWidth = 1.0
        KVNProgress.setConfiguration(configuration)
        KVNProgress.showWithStatus("", onView: view)
    }
    
    class func dismissLoadingHud(view:UIView) {
        KVNProgress.dismiss()
        
    }
    class func showErrorMessage(message:String)
    {
        let errorView = NSBundle.mainBundle().loadNibNamed("ErrorView", owner: nil, options: nil)[0] as? ErrorView
        errorView?.messageLabel.text = message
        errorView?.frame = CGRectMake(0, 0, ScreenSize.SCREEN_WIDTH - 80, 250)
        errorView?.imageView.image = UIImage(named: "close_button")
        let popup = KLCPopup(contentView: errorView, showType: .BounceInFromTop, dismissType: .FadeOut, maskType: .Dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.showWithDuration(2.0)
    }
    
    class func showSuccessMessage(message:String)
    {
        let errorView = NSBundle.mainBundle().loadNibNamed("ErrorView", owner: nil, options: nil)[0] as? ErrorView
        errorView?.imageView.image = UIImage(named: "valid")
        errorView?.messageLabel.text = message
        let popup = KLCPopup(contentView: errorView, showType: .BounceInFromTop, dismissType: .FadeOut, maskType: .Dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        popup.showWithDuration(2.0)
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
    
    
    class func getStringFromInt(integer:Int) -> String {
        if integer < 1000 {
            return String(integer)
        }else{
            let x = Double(integer) / 1000.0
            let y = Double(round(x * 10) / 10)
            return "\(y)k"
        }
        
    }
}