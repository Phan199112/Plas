//
//  AppTokenModel.swift
//  Blasteem
//
//  Created by k on 8/18/16.
//  Copyright © 2016 beneta. All rights reserved.
//


class AppTokenModel: NSObject {
    var access_token : String?
    var expires_in : Double?
    var refresh_token : String?
    var scope : String?
    
    init(access_token :String?,expires_in:Double?,refresh_token:String?,scope:String?) {
        self.access_token = access_token
        self.expires_in = expires_in
        self.refresh_token = refresh_token
        self.scope = scope
        
    }
    required convenience init(coder aDecoder:NSCoder) {
        let access_token = aDecoder.decodeObjectForKey("access_token") as? String
        
        let expires_in = aDecoder.decodeObjectForKey("expires_in") as? Double
        let refresh_token = aDecoder.decodeObjectForKey("refresh_token") as? String
        let scope = aDecoder.decodeObjectForKey("scope") as? String
        
        self.init(access_token: access_token ,expires_in: expires_in,refresh_token: refresh_token,scope: scope)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(refresh_token, forKey: "refresh_token")
        aCoder.encodeObject(scope, forKey: "scope")
        
    }

}
