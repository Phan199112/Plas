//
//  HomeTableViewCell.swift
//  Blasteem
//
//  Created by k on 8/21/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell,UIAlertViewDelegate {

    @IBOutlet weak var isFavoriteImageView: UIImageView!
    @IBOutlet weak var view_count: UILabel!
    @IBOutlet weak var motherView: UIView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var blastCountLabel: UILabel!
    @IBOutlet weak var halfBlastLabel: UILabel!
    weak var homeVC:HomeViewController?
    var video:VideoModel?{
        didSet{
            self.configureCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell() {
        if let videoimage = video?.video_image {
            self.contentImageView.sd_setImageWithURL(NSURL(string: videoimage))
        }
        
        if (video?.is_following_creator)! {
            self.isFavoriteImageView.image = UIImage(named: "check")
        }else{
            
            self.isFavoriteImageView.image = UIImage(named: "home_ic_plus_button")
        }
        
        if let avatarImage = video?.creator?.profile_image {
            self.avatarImageView.sd_setImageWithURL(NSURL(string: avatarImage))
        }
        
        self.usernameLabel.text = video?.creator?.name?.uppercaseString
        self.titleLabel.text = video?.post_title?.uppercaseString
        if let count = video?.view_count {
            self.view_count.text = AppUtil.getStringFromInt(count)
        }
        
        if let count = video?.like_count {
            halfBlastLabel.text = AppUtil.getStringFromInt(count)
        }
        if let count = video?.blast_count {
            blastCountLabel.text = AppUtil.getStringFromInt(count)
        }
        
        Utils.makeCircleFromRetacgleView(self.avatarImageView, radius: 14)
    }
    

    @IBAction func goToCreatorPage(sender: AnyObject) {
        AppSetting.setNone()
        let request = RequestBuilder()
        request.url = ApiUrl.GET_CREATOR_INFO
        request.addParameterWithKey("creatorid", value: (self.video?.creator?.creator_id)!)
        
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                let creator = responseBuilder.getCreatorInfo()
                let origin_creator = self.video?.creator
                origin_creator!.blast_count = creator.blast_count
                origin_creator!.view_count = creator.view_count
                origin_creator!.follower_count = creator.follower_count
                AppSetting.setNone()
                NSNotificationCenter.defaultCenter().postNotificationName("SlideMenuNotification", object: nil,userInfo: ["menu":SlideMenu.creatorProfile.rawValue])
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let creatorDetailVC = storyboard.instantiateViewControllerWithIdentifier("CreatorDetailTableViewController") as? CreatorDetailTableViewController
                
                
                creatorDetailVC?.creator = origin_creator
                self.homeVC?.navigationController?.pushViewController(creatorDetailVC!, animated: true)
                
            }else{
                
            }
            }, errorHandler: { (error) in
                AppUtil.disappearLoadingHud()
                
        })

    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onFollowUser(sender: AnyObject) {
        
        if (video?.is_following_creator)! {
           return
            
        }else{
            
            let alert = UIAlertView(title: "", message: "Seguire " + self.video!.creator!.name! + "?", delegate: self, cancelButtonTitle: "NO", otherButtonTitles: "SI")
            alert.show()
            
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        let request = RequestBuilder()
        request.url = ApiUrl.FOLLOW_AUTHOR
        request.addParameterWithKey("creatorid", value: (self.video!.creator?.creator_id)!)
        request.addParameterWithKey("followerid", value: AppSetting.current_user_id!)
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                self.homeVC!.loadFavoriteUsers((self.video?.creator?.creator_id!)!)
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
            }, errorHandler: { (error) in
                AppUtil.disappearLoadingHud()
                
        })
    }
    
 }
