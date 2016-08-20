//
//  ResponseBuilder.swift
//  Blasteem
//
//  Created by k on 8/18/16.
//  Copyright © 2016 beneta. All rights reserved.
//


class ResponseBuilder: NSObject {
    var response:NSDictionary?
    var reason:String?
    var isSuccessful:Bool?
    
    init(response:NSDictionary) {
        self.response = response
        if let success = response.objectForKey("code") as? String{
            if success == "success"
            {
                isSuccessful = true
            }else{
                isSuccessful = false
                reason = response.objectForKey("message") as? String
            }
        }
    }
    
    func registerResponseHandler(user:UserModel) -> Void {
        user.avatar_url = response?.objectForKey("user_image") as? String
        user.user_id = response?.objectForKey("user_id") as? String
        USER_DEFAULTS.setObject(NSKeyedArchiver.archivedDataWithRootObject(user), forKey: Current_User)
        AppSetting.currentUser = user
    }
}
