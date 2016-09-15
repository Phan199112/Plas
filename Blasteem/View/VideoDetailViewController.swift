//
//  VideoDetailViewController.swift
//  Blasteem
//
//  Created by k on 8/25/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class VideoDetailViewController: UIViewController,BCOVPlaybackControllerDelegate,BCOVPUIPlayerViewDelegate ,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate{
    
    let kViewControllerCatalogToken = "BCpkADawqM21RvYi3po8jqdoGOu_O_1h-wNDXpXzMWsup6VzgmlgEsBYJLrKwo2SgWKz2Na-wLoue64WnbfrkXv_t2h8Q0c6zB1G-O9T3lf7XaJEwJ9FLqDJ_rBt0jXRiPkInor7sIHFCkEc"
    let playlistID = "4593825305001"
    var playbackController:BCOVPlaybackController?
    var loadingFlag:Bool = false
    var service:BCOVPlaybackService?
    var timer:NSTimer?
    var reply_comment:CommentModel?
    
    @IBOutlet weak var sliderBar: UISlider!
    var isPlay:Bool = false
    @IBOutlet weak var creator_viewCount: UILabel!
    @IBOutlet weak var creator_avatarImageView: UIImageView!
    @IBOutlet weak var creator_nameLabel: UILabel!
    
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var videoView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fullScreenButton: UIButton!
    
    @IBOutlet weak var playpauseButton: UIButton!
    
    var currentPlayer:AVPlayer?
    
    var playerView:BCOVPUIPlayerView?
    
    var homeVC:HomeViewController?
    
    var originalOffset:CGPoint?
    var creatorVC:CreatorDetailTableViewController?
    var fireDate:NSDate?
    
    @IBOutlet weak var videoConstraints: NSLayoutConstraint!
    var isFullScreenShow:Bool = false
    var originalFrame:CGRect?
    
    //Models
    var videoArray:[VideoModel] = [VideoModel]()
    var video:VideoModel?
    var commentArray:[CommentModel] = [CommentModel]()
    var isFullShow:Bool = false
    
    var commentHeaderView = NSBundle.mainBundle().loadNibNamed("CommentHeaderView", owner: nil, options: nil)[0] as? CommentHeaderView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.interactivePopGestureRecognizer!.enabled = false
        self.commentHeaderView?.commentButton.addTarget(self, action: #selector(VideoDetailViewController.addComment), forControlEvents: .TouchUpInside)
        // Do any additional setup after loading the view.
        self.tableView.registerClass(RelateVideoTableViewCell.self, forCellReuseIdentifier: "relateVideoCell")
        self.tableView.registerNib(UINib(nibName: "RelateVideoTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "relateVideoCell")

        self.tableView.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        
        if DeviceType.IS_IPHONE_6 {
            self.heightConstraints.constant = 200
        }
        if DeviceType.IS_IPHONE_5 {
            self.heightConstraints.constant = 180
        }
        
        self.tableView.keyboardDismissMode = .Interactive
        
        self.loadAllData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        self.sliderBar.tintColor = mainColor
        
        let thumbImage = UIImage(named: "10px")
        let thumbSmallImage = UIImage(CGImage: (thumbImage?.CGImage)!, scale: 1, orientation: (thumbImage?.imageOrientation)!)
        self.sliderBar.setThumbImage(thumbSmallImage, forState: .Normal)
        self.sliderBar.value = 0
        self.sliderBar.userInteractionEnabled = false
        
        
    }
    @IBAction func onSliderBegin(sender: AnyObject) {
        let thumbImage = UIImage(named: "20px")
        let thumbSmallImage = UIImage(CGImage: (thumbImage?.CGImage)!, scale: 1, orientation: (thumbImage?.imageOrientation)!)
        self.sliderBar.setThumbImage(thumbSmallImage, forState: .Normal)
        self.playerView?.playbackController.pause()
    }
    
    @IBAction func onSliderEnd(sender: AnyObject) {
        if let videoplayer = self.currentPlayer
        {
            let thumbImage = UIImage(named: "10px")
            let thumbSmallImage = UIImage(CGImage: (thumbImage?.CGImage)!, scale: 1, orientation: (thumbImage?.imageOrientation)!)
            self.sliderBar.setThumbImage(thumbSmallImage, forState: .Normal)
            
         
            let sliderbar = sender as! UISlider
            let newCurrentTime = Float64(sliderbar.value) * CMTimeGetSeconds((self.currentPlayer?.currentItem?.duration)!)
            let seekToTime = CMTimeMakeWithSeconds(newCurrentTime, 600)
            self.currentPlayer?.seekToTime(seekToTime, completionHandler: { (finished) in
                if (finished &&  self.isPlay)
                {
                    self.playbackController?.play()
                }
            })
        }
        
        
    }
    @IBAction func onSliderValueChanged(sender: AnyObject) {
        
    }
    func loadAllData() {
        
        if let video_id = video?.blast_id
        {
            self.loadVideoInfo(video_id)
            
            self.getComments(video_id)
        }
        
        
    }
    
    func loadVideoInfo(video_id:String) {
        let request = RequestBuilder()
        request.url = ApiUrl.GET_SINGLE_VIDEO_INFO
        
        request.addParameterWithKey("postid", value: video_id)
        request.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            
            if responseBuilder.isSuccessful!
            {
                
                let video = responseBuilder.getSingleVideoinfo()
                
                self.video = video
                let request1 = RequestBuilder()
                request1.url = ApiUrl.VALIDATE_FOLLOW_CREATOR
                request1.addParameterWithKey("creatorid", value: (self.video?.creator?.creator_id)!)
                request1.addParameterWithKey("followerid", value: AppSetting.current_user_id!)
                
                ComManager().postRequestToServer(request1, successHandler: { (responseBuilder) in
                    
                    if responseBuilder.isSuccessful!
                    {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.video?.is_following_creator = responseBuilder.validateCreatorFollow()
                            self.loadData(video_id)
                            self.configureView()
                            self.setupVieoView()
                        }
                        
                    }else{
                        AppUtil.disappearLoadingHud()
                        AppUtil.showErrorMessage(responseBuilder.reason!)
                    }
                    }, errorHandler: { (error) in
                        
                })
               
            }else{
                AppUtil.disappearLoadingHud()
                AppUtil.showErrorMessage(responseBuilder.reason!)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }) { (error) in
            AppUtil.disappearLoadingHud()
            
        }

    }
    
    func getComments(video_id:String) {
        let request = RequestBuilder()
        request.url = ApiUrl.GET_COMMENTS
        
        request.addParameterWithKey("postid", value:video_id)
        
        
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {

                self.commentArray = responseBuilder.getComments()
                
                let sections = NSIndexSet(index: 1)
                
                self.tableView.reloadSections(sections, withRowAnimation: .None)
                
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
        }) { (error) in
            AppUtil.disappearLoadingHud()
            
        }
    }
    
    func onTimer(timer:NSTimer) {
        if NSDate().timeIntervalSinceDate(fireDate!) > 3.0
        {
            timer.invalidate()
            self.playpauseButton.hidden = true
            self.fullScreenButton.hidden = true
        }
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
                
                self.video?.is_following_creator = !(self.video?.is_following_creator)!
                self.showIsFavorite()
                
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
            }, errorHandler: { (error) in
                AppUtil.disappearLoadingHud()
                
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.playerView = nil
        AppUtil.disappearLoadingHud()
    }
    
    func showIsFavorite() {
        
        if (video?.is_following_creator)! {
            self.favoriteImageView.image = UIImage(named: "check")
        }else{
            
            self.favoriteImageView.image = UIImage(named: "home_ic_plus_button")
        }
    }
    func configureView()
    {
        //Headerview of Table
        showIsFavorite()
        showVideoDetail()
        self.playpauseButton.hidden = true
        Utils.makeCircleFromRetacgleView(self.creator_avatarImageView, radius: 20)
        self.creator_nameLabel.text = self.video?.creator?.name?.uppercaseString
        self.creator_avatarImageView.sd_setImageWithURL(NSURL(string: (video?.creator?.profile_image)!))
        if let view_count = video?.view_count {
            self.creator_viewCount.text = AppUtil.getStringFromInt(view_count)
        }
        
        Utils.makeCircleFromRetacgleView(self.playpauseButton, radius: 30)
        Utils.makeCircleFromRetacgleView(self.fullScreenButton, radius: 20)
//        self.progressBar.progressTintColor = mainColor
//        self.progressBar.progress = 0
        

    }
    
    func showVideoDetail()  {
        let videoDetailview = NSBundle.mainBundle().loadNibNamed("VideoDetailHeaderView", owner: nil, options: nil)[0] as? VideoDetailHeaderView
        videoDetailview?.heightConstraints.constant = Utils.getHeightOfString(self.video?.post_content!, width: ScreenSize.SCREEN_WIDTH - 16, andFont: AppFont.OpenSans_15)
        if let count = video?.blast_count {
            videoDetailview?.blast_countLabel.text = AppUtil.getStringFromInt(count)
        }
        
        videoDetailview?.isBlasted = video?.is_blasted
        videoDetailview?.titleLabel.text = (video?.post_title)?.uppercaseString
        
        
        if let post_date =  video?.post_date
        {
            let localIdentifier = "it_IT"
            let locale = NSLocale(localeIdentifier: localIdentifier)
            let dateformatter = NSDateFormatter()
            dateformatter.locale = locale
            dateformatter.dateFormat = "dd MMMM yyyy"
            if let date = NSDate(fromString: post_date, withFormat: "yyyy-MM-dd HH:mm:ss") {
                let local_date = dateformatter.stringFromDate(date)
                videoDetailview?.dateLabel.text = local_date
            }
            
        }
        videoDetailview?.postContentTextView.text = video?.post_content
        videoDetailview?.frame = CGRectMake(0, 0, ScreenSize.SCREEN_WIDTH, 145 + Utils.getHeightOfString(self.video?.post_content!, width: ScreenSize.SCREEN_WIDTH - 16, andFont: AppFont.OpenSans_15))
        videoDetailview?.blastButton.addTarget(self, action: #selector(VideoDetailViewController.onBlast(_:)), forControlEvents: .TouchUpInside)
        if (video?.is_blasted)! {
            videoDetailview?.blastButton.setBackgroundImage(UIImage(named: "unblast"), forState: .Normal)
        }else{
            videoDetailview?.blastButton.setBackgroundImage(UIImage(named: "blast icon"), forState: .Normal)
        }
        if (video?.is_liked)! {
            videoDetailview?.likeButton.setBackgroundImage(UIImage(named: "unlike"), forState: .Normal)
        }else{
            videoDetailview?.likeButton.setBackgroundImage(UIImage(named: "likeicon"), forState: .Normal)
        }
        
        if let count = video?.like_count {
            videoDetailview?.like_countLabel.text = AppUtil.getStringFromInt(count)
        }
        videoDetailview?.likeButton.addTarget(self, action: #selector(VideoDetailViewController.onLike(_:)), forControlEvents: .TouchUpInside)
         videoDetailview?.shareButton.addTarget(self, action: #selector(VideoDetailViewController.shareVideo), forControlEvents: .TouchUpInside)
        self.tableView.tableHeaderView = videoDetailview!

    }
    func onBlast(sender:UIButton)  {
        let request = RequestBuilder()
        request.url = ApiUrl.BLAST_VIDEO
        var blast_key = "Y"
        if (video?.is_blasted)! {
            blast_key = "N"
        }
        AppUtil.showLoadingHud()
        request.addParameterWithKey("postid", value: String((video?.blast_id)!))
        request.addParameterWithKey("blastit", value: blast_key)
        request.addParameterWithKey("userid", value: String(AppSetting.current_user_id!))
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                self.video?.is_blasted = !((self.video?.is_blasted)!)
                if (self.video?.is_blasted)!
                {
                    self.video?.blast_count = (self.video?.blast_count)! + 1
                }else{
                    self.video?.blast_count = (self.video?.blast_count)! - 1
                }
                
                self.showVideoDetail()
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
        }) { (error) in
            AppUtil.disappearLoadingHud()
            
        }

    }
    
    func onLike(sender:UIButton) {
        let request = RequestBuilder()
        request.url = ApiUrl.LIKE_VIDEO
        var like_key = "Y"
        if (video?.is_liked)! {
            like_key = "N"
        }
        AppUtil.showLoadingHud()
        request.addParameterWithKey("postid", value: String((video?.blast_id)!))
        request.addParameterWithKey("likeit", value: like_key)
        request.addParameterWithKey("userid", value: String(AppSetting.current_user_id!))
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                self.video?.is_liked = !((self.video?.is_liked)!)
                if (self.video?.is_liked)!
                {
                    self.video?.like_count = (self.video?.like_count)! + 1
                }else{
                    self.video?.like_count = (self.video?.like_count)! - 1
                }
                
                self.showVideoDetail()
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
        }) { (error) in
            AppUtil.disappearLoadingHud()
            
        }
    }
    
    func shareVideo() {
        let shareText = video?.video_url as! AnyObject

        let itemToShare = [shareText]
        let activityVC = UIActivityViewController(activityItems: itemToShare, applicationActivities: nil)
        AppUtil.showLoadingHud()
        self.presentViewController(activityVC, animated: true) { 
            AppUtil.disappearLoadingHud()
        }
    }
    
    @IBAction func showFullScreen(sender: AnyObject) {
        if isFullScreenShow {
            let value = UIInterfaceOrientation.Portrait.rawValue
//            topConstraint.constant = 0
            let navVC = self.navigationController as! RootNavViewController
            navVC.isLandScape = true
            videoConstraints.constant = 44
            if DeviceType.IS_IPHONE_6 {
                self.heightConstraints.constant = 200
            }
            if DeviceType.IS_IPHONE_5 {
                self.heightConstraints.constant = 180
            }
            if DeviceType.IS_IPHONE_4_OR_LESS {
                self.heightConstraints.constant = 150
            }
            self.videoView.frame = originalFrame!
            self.fullScreenButton.setBackgroundImage(UIImage(named: "ic_fullscreen"), forState: .Normal)
            self.view.layoutIfNeeded()
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            isFullScreenShow = false
            navVC.isLandScape = false
            
            
        }else{
            let navVC = self.navigationController as! RootNavViewController
            navVC.isLandScape = true
            
            let value = UIInterfaceOrientation.LandscapeLeft.rawValue
            originalFrame = self.videoView.frame
            topConstraint.constant = -10
            videoConstraints.constant = 0
            self.fullScreenButton.setBackgroundImage(UIImage(named: "ic_fullscreen_exit"), forState: .Normal)
            let bound = self.view.bounds
            
            self.videoView.frame = bound
            
            heightConstraints.constant = bound.height + 20
            self.view.layoutIfNeeded()
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            
            isFullScreenShow = true
            navVC.isLandScape = false
            
        }
        
    }
  
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
            return UIInterfaceOrientationMask.All
        
    }
    
    @IBAction func onBack(sender: AnyObject) {
        
        self.playerView?.playbackController.pause()
        self.playerView?.playbackController = nil
        let navVC = self.navigationController as? RootNavViewController
        navVC!.isLandScape = false

        ViewManager.sharedInstance.popToMainPage()
    }
    
    @IBAction func tapVideo(sender: AnyObject) {
        self.view.endEditing(true)
        if isPlay {
            self.playpauseButton.hidden = false
            self.fullScreenButton.hidden = false
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(VideoDetailViewController.onTimer(_:)), userInfo: nil, repeats: true)
            fireDate = NSDate()
        }
    }
    
    func loadData(video_id:String) {

        
        let request = RequestBuilder()
        request.url = ApiUrl.GET_VIDEO_LIST
        request.addParameterWithKey("page", value: "1")
        request.addParameterWithKey("exclude_ids", value: video_id)
        request.addParameterWithKey("creator_id", value: String((self.video?.creator?.creator_id)!))
        request.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
        
        
        ComManager().getVideoList(request, successHandler: { (responseBuilder) in
            if responseBuilder.isSuccessful!
            {
                AppUtil.disappearLoadingHud()
                self.videoArray = responseBuilder.getVideoList()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }else{
                AppUtil.disappearLoadingHud()
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
        }) { (error) in
            AppUtil.disappearLoadingHud()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupVieoView() {
        let manager = BCOVPlayerSDKManager.sharedManager()
        playbackController =  manager.createPlaybackController()
        playbackController?.delegate = self
        playbackController?.autoAdvance = true
        
        playbackController?.autoPlay = true
        
        playbackController?.allowsBackgroundAudioPlayback = true
        
        playerView = BCOVPUIPlayerView(playbackController: playbackController, options: nil, controlsView: nil)
        
        playerView!.frame = self.videoView.bounds
        playerView!.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        self.videoView.addSubview(playerView!)
        
        playerView!.layer.zPosition = -100
        
        playerView!.playbackController = playbackController
        service = BCOVPlaybackService(accountId: playlistID, policyKey: kViewControllerCatalogToken)
        AppUtil.showLoadingHudOnView(self.videoView)
        loadingFlag = true
        service?.findVideoWithVideoID(video?.video_id, parameters: nil, completion: { (video, jsonResponse, error) in
            if video != nil
            {
                dispatch_async(dispatch_get_main_queue(),{
                    self.playerView!.playbackController?.setVideos([video])
                    //            self.playbackController?.play()
                    self.isPlay = true
                    
                })
                
            }
        })
    }

    
    @IBAction func onPlayPause(sender: AnyObject) {
        timer?.invalidate()
        AppUtil.dismissLoadingHud(self.videoView)
        if isPlay {
            self.playpauseButton.setBackgroundImage(UIImage(named: "ic_play"), forState: .Normal)
            self.playerView!.playbackController?.pause()
            isPlay = false
        }else{
            self.playpauseButton.setBackgroundImage(UIImage(named: "ic_pause"), forState: .Normal)
            self.playerView!.playbackController?.play()
            self.playpauseButton.hidden = true
            self.fullScreenButton.hidden = true
            isPlay = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if isFullShow {
                return videoArray.count
            }else{
                if videoArray.count > 3 {
                    return 3
                }else{
                    return videoArray.count
                }
            }
        }else{
            return commentArray.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let relateVideCell:RelateVideoTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("relateVideoCell") as! RelateVideoTableViewCell
       
        
        if indexPath.section == 0 {
            relateVideCell.video = videoArray[indexPath.row]
            relateVideCell.configureCell()
            relateVideCell.homeVC = self
            return relateVideCell
        }else{
            let commentCell = self.tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as? CommentTableViewCell
            commentCell?.comment = commentArray[indexPath.row]
            commentCell?.comment_index = indexPath.row
            commentCell?.homeVC = self
            
            commentCell?.configureCell()
            return commentCell!
        }
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = UIView(frame: CGRectMake(0,0,ScreenSize.SCREEN_WIDTH,60))
            footerView.backgroundColor = UIColor.whiteColor()
            let button = UIButton(frame: CGRectMake((ScreenSize.SCREEN_WIDTH - 25)/2,30,25,14))
            let selectbutton = UIButton(frame: CGRectMake((ScreenSize.SCREEN_WIDTH - 25)/2,30,30,30))
            if isFullShow {
                button.setBackgroundImage(UIImage(named: "up_arrow"), forState: .Normal)
                
            }else{
                button.setBackgroundImage(UIImage(named: "down_arrow"), forState: .Normal)
                
            }
            selectbutton.addTarget(self, action: #selector(VideoDetailViewController.controlFullShow(_:)), forControlEvents: .TouchUpInside)
            footerView.addSubview(button)
            footerView.addSubview(selectbutton)
            return footerView
        }else{
            return nil
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        if indexPath.section == 0 {
//            self.video = self.videoArray[indexPath.row]
            self.playerView?.playbackController.pause()
            self.playerView?.playbackController = nil
            self.navigationController?.popViewControllerAnimated(false)
            ViewManager.sharedInstance.showVideoPage(self.videoArray[indexPath.row], homeVC: nil, creatorVC: nil)
        }
    }
    func controlFullShow(sender:UIButton) {
        isFullShow = !isFullShow
        let sections = NSIndexSet(index: 0)
        
        self.tableView.reloadSections(sections, withRowAnimation: .None)
        
    }
    
    func respondCommentSelected(comment: CommentModel) {
    
        self.reply_comment = comment
        
        self.commentHeaderView!.commentField.text = "@" + (comment.comment_author_name)! + ":"
        self.commentHeaderView!.commentField.becomeFirstResponder()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            
            return nil
        }else{
            commentHeaderView?.commentField.delegate = self
            return commentHeaderView
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if DeviceType.IS_IPHONE_4_OR_LESS {
            heightConstraints.constant = 70
            self.view.layoutSubviews()
        }
        var firstsectionCount:Int = 0
        if isFullShow {
            firstsectionCount = self.videoArray.count
        }else{
            firstsectionCount = 3
        }
        let headerHeight = 145 + Utils.getHeightOfString(self.video?.post_content!, width: ScreenSize.SCREEN_WIDTH - 16, andFont: AppFont.OpenSans_15)
        originalOffset = self.tableView.contentOffset
        self.tableView.setContentOffset(CGPointMake(0, headerHeight + 111 * CGFloat(firstsectionCount) + 110), animated: true)
        
    }
    
    deinit
    {
        self.playerView?.playbackController.setVideos(nil)
        self.playerView = nil
        self.playbackController = nil
        timer?.invalidate()
        timer = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    func keyboardWillHide(notification:NSNotification){
        if DeviceType.IS_IPHONE_4_OR_LESS {
            heightConstraints.constant = 150
            self.view.layoutSubviews()
        }
        
    }

    func addComment() {
        self.view.endEditing(true)
        let request = RequestBuilder()
        request.url = ApiUrl.ADD_COMMENTS
        if !Utils.checkIfStringContainsText(self.commentHeaderView!.commentField.text) {
            AppUtil.showErrorMessage("Commento richiesta")
            return
        }
        request.addParameterWithKey("postid", value: String((video?.blast_id)!))
        request.addParameterWithKey("userid", value: AppSetting.current_user_id!)
        request.addParameterWithKey("usercomment", value: (self.commentHeaderView?.commentField.text!)!)
        
        if let comment = reply_comment {
            
            request.addParameterWithKey("commentparentid", value: comment.comment_id!)
            
        }
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                
                self.commentHeaderView?.commentField.text = ""
                if let video_id = self.video?.blast_id{
                    self.getComments(video_id)
                }
                
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
        }) { (error) in
            AppUtil.disappearLoadingHud()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else{
            return 120
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 111
        }else{
            return 120
        }
    }
   
    //PlaybackController Delegates
    func playbackController(controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didProgressTo progress: NSTimeInterval) {
        
        let duration = CMTimeGetSeconds((session.player.currentItem?.duration)!) as NSTimeInterval
        var percent:Float = 0
        if !isnan(duration) {
            AppUtil.dismissLoadingHud(self.videoView)
            self.sliderBar.userInteractionEnabled = true
            percent = Float(progress / duration)
        }
        self.sliderBar.value = percent
//        self.progressBar.progress = percent
//        NSTimeInterval duration = CMTimeGetSeconds(session.player.currentItem.duration);
//        float percent = progress / duration;
//        self.playheadSlider.value = isnan(percent) ? 0.0f : percent;
    }
    
    func playbackController(controller: BCOVPlaybackController!, didAdvanceToPlaybackSession session: BCOVPlaybackSession!) {
        self.currentPlayer = session.player
    }
    
   
    //     override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool {
    //        return UIInterfaceOrientationIsPortrait(interfaceOrientation)
    //    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
