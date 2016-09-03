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
        AppSetting.current_user_id = user.user_id
        ViewManager.sharedInstance.showHomePage()
    }
    
    func loginResponseHandler() -> Int {
        USER_DEFAULTS.setBool(true, forKey: IS_LOGIN)
        USER_DEFAULTS.setObject((response?.objectForKey("user_id") as! Int), forKey: Current_User_ID)
        
         return (response?.objectForKey("user_id") as? Int)!
    }
    
    func validateSocialUser() -> Bool {
        
        if response?.objectForKey("registered") as? String == "N" {
            return false
        }else{
            USER_DEFAULTS.setBool(true, forKey: IS_LOGIN)
            USER_DEFAULTS.setObject((response?.objectForKey("user_id") as! Int), forKey: Current_User_ID)
            AppSetting.current_user_id = self.response?.objectForKey("user_id") as? Int
            return true
        }
    }
    
    func getUserInfo() -> UserModel{
        
        let user_info_optional = response?["user_info"] as? [String:AnyObject]
        if let user_info = user_info_optional {
            let first_name = user_info["first_name"] as? String
            let last_name = user_info["last_name"] as? String
            //        let url = response?.objectForKey("url") as? String
            //        let description = response?.objectForKey("description") as? String
            let avatar_url = user_info["user_image"] as? String
            let user_email = user_info["user_email"] as? String
            let blasteem_data_di_nascita = user_info["blasteem_data_di_nascita"] as? String
            let gender = user_info["gender"] as? String
            let country = user_info["country"] as? String
            let user_login = user_info["user_login"] as? String
            let is_mail_str = user_info["mailchimp_subscribe"] as? String
            var is_mail:Bool = false
            if is_mail_str == "Y" {
                is_mail = true
            }
            
            AppSetting.currentUser = UserModel(user_id: AppSetting.current_user_id, fb_id: nil, google_id: nil, avatar_url: avatar_url, avatar_data: nil, firstname: first_name, lastname: last_name, birthdate: NSDate(fromString: blasteem_data_di_nascita, withFormat: "dd-MM-yyyy"), sex: gender, address: country, email: user_email, username: user_login, password: nil, user_link: nil)
            AppSetting.currentUser?.is_agreed_news = is_mail
        }
        
        

        return AppSetting.currentUser!
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
                if  let like_count = video_dict["like_count"] as? String{
                    video.like_count = Int(like_count)
                }
                if  let blast_count = video_dict["blast_count"] as? String{
                    video.blast_count = Int(blast_count)
                }
                video.post_date = video_dict["post_date"] as? String
                video.post_title = video_dict["post_title"] as? String
                video.video_id = video_dict["video_id"] as? String
                
                
                if  let view_count:String = video_dict["views"] as? String {
                    video.view_count = Int(view_count)
                }
                video.video_image = video_dict["video_image"] as? String
                video.blast_id = video_dict["ID"] as? String
                video.post_content = video_dict["post_content"] as? String
                if let str = video_dict["is_following_creator"] as? String {
                    if str == "N" {
                        video.is_following_creator = false
                    }else{
                        video.is_following_creator = true
                    }
                }
                return_arr.append(video)
            }
        }
        
        return return_arr
    }
    
    func getMeetsAndNews(type:String) -> [VideoModel] {
        var return_arr = [VideoModel]()
        var video_list:Array<[String:AnyObject]>?
        if type == ApiUrl.GET_NEWS_LIST {
            video_list = response!["news_list"] as? Array<[String:AnyObject]>
        }else{
            video_list = response!["meets_list"] as? Array<[String:AnyObject]>
        }
        if video_list != nil {
            for video_dict in video_list! {
                let video = VideoModel()
                //Others
                video.post_date = video_dict["post_date"] as? String
                video.post_title = video_dict["post_title"] as? String
                if type == ApiUrl.GET_NEWS_LIST {
                    video.video_image = video_dict["news_image"] as? String
                    
                }else{
                    video.video_image = video_dict["meets_image"] as? String
                    
                }
                video.blast_id = video_dict["ID"] as? String
                video.video_url = video_dict["guid"] as? String
                return_arr.append(video)
            }

        }
        return return_arr
    }
    
    func getCategories() ->[CategoryModel] {
        var return_arr:[CategoryModel] = [CategoryModel]()
        let category_list = response!["categories_list"] as? Array<[String:AnyObject]>
        for category_dict in category_list! {
            let category:CategoryModel = CategoryModel()
            category.category_title = (category_dict["cat_name"] as? String)?.uppercaseString
            category.category_id = category_dict["term_id"] as? Int
            return_arr.append(category)
        }
        return return_arr
    }
    
    func getCreators() ->[CreatorModel] {
        var return_arr:[CreatorModel] = [CreatorModel]()
        let creator_list = response!["creator_list"] as? Array<[String:AnyObject]>
        for creator_dict in creator_list! {
            let creator:CreatorModel = CreatorModel()
            creator.name = creator_dict["name"] as? String
            creator.creator_id = creator_dict["term_id"] as? Int
            creator.profile_image = creator_dict["profile_picture"] as? String
            return_arr.append(creator)
        }
        return return_arr
    }
    
    func getSubscriptions() ->[CreatorModel] {
        var return_arr:[CreatorModel] = [CreatorModel]()
        let creator_list = response!["subscriptions"] as? Array<[String:AnyObject]>
        for creator_dict in creator_list! {
            let creator:CreatorModel = CreatorModel()
            creator.name = creator_dict["name"] as? String
            creator.creator_id = creator_dict["term_id"] as? Int
            creator.profile_image = creator_dict["profile_picture"] as? String
            return_arr.append(creator)
        }
        return return_arr
    }
    func getCreatorInfo() -> CreatorModel {
        let creator = CreatorModel()
        let temp_dict1 = response!["creator_info"] as? [String:String]
        if let temp_dict = temp_dict1 {
            
            creator.name = temp_dict["name"]
            creator.profile_image = temp_dict["profile_picture"]
            creator.follower_count = Int(temp_dict["no_of_followers"]!)
            creator.blast_count = Int(temp_dict["no_of_blast"]!)
            creator.view_count = Int(temp_dict["no_of_views"]!)
            
        }
        return creator
    }
    
    func validateCreatorFollow() -> Bool {
        let key = response?.objectForKey("following") as! String
        if key == "Y" {
            return true
        }else{
            return false
        }
    }
    
    func getComments() -> [CommentModel] {
        var return_arr = [CommentModel]()
        let temp_arr = response!["comments_list"] as? Array<[String:AnyObject]>
        for comment_dict in temp_arr! {
            
             let comment = CommentModel()
             comment.comment_id = String(comment_dict["comment_ID"])
             comment.comment_post_id = String(comment_dict["comment_post_ID"] )
             comment.comment_author_name = comment_dict["comment_author"] as? String
             comment.comment_date = comment_dict["comment_date"] as? String
             comment.comment_content = comment_dict["comment_content"] as? String
             comment.user_id = String(comment_dict["user_id"])
             
             comment.author_profile_picture = comment_dict["comment_author_profile_picture"] as? String
             return_arr.append(comment)
            
            
        }
        
        return return_arr
    }
    
    func getSingleVideoinfo() -> VideoModel {
        let video:VideoModel = VideoModel()
        let video_info = response!["video_info"] as! NSDictionary
        if let blast_count = video_info["blast_count"] as? String
        {
            video.blast_count = Int(blast_count)
        }
        if let like_count = video_info["like_count"] as? String {
            video.like_count = Int(like_count)
        }
        if let views = video_info["views"] as? String {
            video.view_count = Int(views)
        }
        if let is_blasted = video_info["is_blasted"] as? String {
            if is_blasted == "N" {
                video.is_blasted = false
            }else{
                video.is_blasted = true
            }
        }
        video.blast_id = video_info["ID"] as? String
        video.video_id = video_info["video_id"] as? String
        video.video_image = video_info["video_image"] as? String
        
        //----Creator Parse
        let creator = CreatorModel()
        let creator_dict = video_info["creator"] as? [String:AnyObject]
        creator.creator_id = creator_dict!["id"] as? Int
        creator.name = creator_dict!["name"] as? String
        creator.profile_image = creator_dict!["profile_image"] as? String
        
        video.creator = creator
        video.post_title = video_info["post_title"] as? String
        video.video_url = video_info["video_url"] as? String
        video.post_date = video_info["post_date"] as? String
        video.post_content = video_info["post_content"] as? String
        return video
    }
    
    func getNotifications() {
        var return_arr = [VideoModel]()
        let video_list = response!["posts"] as? Array<[String:AnyObject]>
        if video_list != nil {
            for video_dict in video_list! {
                let video = VideoModel()
                //----Creator Parse
                let creator = CreatorModel()
                
                creator.creator_id = video_dict["creator_id"] as? Int
                creator.name = video_dict["creator_name"] as? String
                creator.profile_image = video_dict["creator_image"] as? String
                
                video.creator = creator
                video.is_read = video_dict["read"] as? Bool
                //Others
                video.video_image = video_dict["thumbnail"] as? String
                video.blast_id = String(video_dict["id"] as! Int)
                video.post_title = video_dict["title"] as? String
                video.post_date = video_dict["date"] as? String
                return_arr.append(video)
            }
        }
        AppSetting.notification_arr = return_arr
    }
    
    func getCountOfUnRead() -> Int {
        var unread_count = 0
        for video in AppSetting.notification_arr {
            if !(video.is_read!) {
                unread_count = unread_count + 1
            }
        }
        return unread_count
    }
}
