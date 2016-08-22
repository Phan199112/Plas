//
//  UserModel.swift
//  Blasteem
//
//  Created by k on 8/18/16.
//  Copyright © 2016 beneta. All rights reserved.
//



class UserModel: NSObject {
    
    var user_id:Int?
    var fb_id:String?
    var google_id:String?
    var avatar_url:String?
    var avatar_data:NSData?
    var firstname:String?
    var lastname:String?
    var birthdate:NSDate?
    var sex:String?
    var address:String?
    var email:String?
    var username:String?
    var password:String?
    
    var user_link:String?
    
    init(user_id:Int?, fb_id:String?, google_id:String?, avatar_url :String?,avatar_data:NSData?,firstname:String?,lastname:String?,birthdate:NSDate?,sex:String?,address:String?,email:String?,username:String?,password:String?,user_link:String?) {
        
        self.user_id = user_id
        self.fb_id = fb_id
        self.google_id = google_id
        
        self.avatar_url = avatar_url
        self.avatar_data = avatar_data
        self.firstname = firstname
        self.lastname = lastname
        self.birthdate = birthdate
        self.sex = sex
        self.address = address
        self.email = email
        self.username = username
        self.password = password
        self.user_link = user_link
        
    }
    required convenience init(coder aDecoder:NSCoder) {
        let user_id = aDecoder.decodeObjectForKey("user_id") as? Int
        let fb_id = aDecoder.decodeObjectForKey("fb_id") as? String
        let google_id = aDecoder.decodeObjectForKey("google_id") as? String
        
        let avatar_url = aDecoder.decodeObjectForKey("avatar_url") as? String
        let avatar_data = aDecoder.decodeObjectForKey("avatar_data") as? NSData
        let firstname = aDecoder.decodeObjectForKey("firstname") as? String
        let lastname = aDecoder.decodeObjectForKey("lastname") as? String
        let birthdate = aDecoder.decodeObjectForKey("birthdate") as? NSDate
        let sex = aDecoder.decodeObjectForKey("sex") as? String
        let address = aDecoder.decodeObjectForKey("address") as? String
        let email = aDecoder.decodeObjectForKey("email") as? String
        let username = aDecoder.decodeObjectForKey("username") as? String
        let password = aDecoder.decodeObjectForKey("password") as? String
        let user_link = aDecoder.decodeObjectForKey("user_link") as? String
        
        self.init(user_id:user_id, fb_id:fb_id, google_id:google_id, avatar_url: avatar_url, avatar_data: avatar_data, firstname: firstname, lastname: lastname, birthdate:birthdate, sex: sex, address: address, email: email, username: username, password: password, user_link: user_link)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(user_id, forKey: "user_id")
        aCoder.encodeObject(fb_id, forKey: "fb_id")
        aCoder.encodeObject(google_id, forKey: "google_id")
        
        aCoder.encodeObject(avatar_url, forKey: "avatar_url")
        aCoder.encodeObject(avatar_data, forKey: "avatar_data")
        aCoder.encodeObject(firstname, forKey: "firstname")
        aCoder.encodeObject(lastname, forKey: "lastname")
        aCoder.encodeObject(birthdate, forKey: "birthdate")
        aCoder.encodeObject(sex, forKey: "sex")
        aCoder.encodeObject(address, forKey: "address")
        aCoder.encodeObject(email, forKey: "email")
        aCoder.encodeObject(username, forKey: "username")
        aCoder.encodeObject(password, forKey: "password")
        aCoder.encodeObject(user_link, forKey: "user_link")
        
    }
}
