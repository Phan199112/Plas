//
//  VideoModel.swift
//  Blasteem
//
//  Created by k on 8/21/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class VideoModel: NSObject {
    var video_id:String?
    var creator:CreatorModel?
    var like_count:Int?
    var post_date:String?
    var post_title:String?
    var blast_count:Int?
    
    var view_count:Int?
    var video_image:String?
    var blast_id:String?
    var post_content:String?
    var is_following_creator:Bool = false
    var is_blasted:Bool?
    var is_liked:Bool = false
    var video_url:String?
    var is_read:Bool?
}
