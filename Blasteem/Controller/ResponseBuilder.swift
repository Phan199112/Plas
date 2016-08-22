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
                reason = response.objectForKey("message") as? String
            }else{
                isSuccessful = false
                reason = response.objectForKey("message") as? String
            }
        }
    }
    
    func registerResponseHandler(user:UserModel) -> Void {
        user.avatar_url = response?.objectForKey("user_image") as? String
        user.user_id = response?.objectForKey("user_id") as? Int
        USER_DEFAULTS.setObject(NSKeyedArchiver.archivedDataWithRootObject(user), forKey: Current_User)
        USER_DEFAULTS.setBool(true, forKey: IS_LOGIN)
        AppSetting.currentUser = user
        ViewManager.sharedInstance.showHomePage()
    }
    
    func loginResponseHandler() -> Int {
        
         return (response?.objectForKey("user_id") as? Int)!
    }
    
    func validateSocialUser() -> Bool {
        if response?.objectForKey("registered") as? String == "N" {
            return false
        }else{
            return true
        }
    }
    
    func getUserInfo() {
        USER_DEFAULTS.setBool(true, forKey: IS_LOGIN)
        let user_id = response?.objectForKey("id") as? Int
        let user_name = response?.objectForKey("name") as? String
        let names:[String] = (user_name?.componentsSeparatedByString(" "))!
        
//        let url = response?.objectForKey("url") as? String
//        let description = response?.objectForKey("description") as? String
        let link = response?.objectForKey("link") as? String
//        let slug = response?.objectForKey("slug") as? String
        let avatar_urls = response?.objectForKey("avatar_urls") as? String
        let user_email = response?.objectForKey("user_email") as? String
        let blasteem_data_di_nascita = response?.objectForKey("blasteem_data_di_nascita") as? String
        let gender = response?.objectForKey("gender") as? String
        let country = response?.objectForKey("country") as? String
        let user_login = response?.objectForKey("user_login") as? String
//        let profilepicture = response?.objectForKey("profilepicture") as? String
        let facebook = response?.objectForKey("facebook") as? String
        let google = response?.objectForKey("google_plus") as? String
//        let user_url = response?.objectForKey("user_url") as? String
//        let _links = response?.objectForKey("_links") as? String
        AppSetting.currentUser = UserModel(user_id: user_id, fb_id: facebook, google_id: google, avatar_url: avatar_urls, avatar_data: nil, firstname: names[0], lastname: names[1], birthdate: NSDate(fromString: blasteem_data_di_nascita, withFormat: "dd-MM-yyyy"), sex: gender, address: country, email: user_email, username: user_login, password: nil, user_link: link)
        USER_DEFAULTS.setObject(NSKeyedArchiver.archivedDataWithRootObject((AppSetting.currentUser)!), forKey: Current_User)
    }
    
    func getVideoList() -> [VideoModel] {
        var return_arr = [VideoModel]()
        let video_list = response!["video_list"] as? Array<[String:AnyObject]>
        if video_list != nil {
            for video_dict in video_list! {
                let video = VideoModel()
                //----Creator Parse
                let creator = CreatorModel()
                let creator_dict = video_dict["creator"] as? [String:AnyObject]
                creator.creator_id = creator_dict!["id"] as? Int
                creator.name = creator_dict!["name"] as? String
                creator.profile_image = creator_dict!["profile_image"] as? String
                video.creator = creator
                
                //Others
                video.like_count = Int((video_dict["like_count"] as! String))
                video.post_date = video_dict["post_date"] as? String
                video.post_title = video_dict["post_title"] as? String
                video.video_id = Int((video_dict["video_id"] as! String))
                video.blast_count = Int((video_dict["blast_count"] as! String))
                video.view_count = Int((video_dict["views"] as! String))
                video.video_image = video_dict["video_image"] as? String
                video.some_id = Int((video_dict["ID"] as! String))
                video.post_content = video_dict["post_content"] as? String
                return_arr.append(video)
            }
        }
        
        return return_arr
    }
    
    func getCategories() ->[String] {
        var return_arr:[String] = [String]()
        let category_list = response!["categories_list"] as? Array<[String:AnyObject]>
        for category_dict in category_list! {
            
        }
        return return_arr
    }
}
