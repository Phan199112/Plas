//
//  CreatorDetailTableViewController.swift
//  Blasteem
//
//  Created by k on 8/23/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class CreatorDetailTableViewController: UITableViewController,UIAlertViewDelegate{

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var blastLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    var creator:CreatorModel?
    {
        didSet{
            
        }
    }
    var videoArray:[VideoModel] = [VideoModel]()
    var bucketArray:[VideoModel] = [VideoModel]()
    
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var offset:Int = 1
    var isLoadMore:Bool = false
    var is_follow:Bool = false
    var alert1:UIAlertView?
    var alert2:UIAlertView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.registerNib(UINib(nibName: "CreatorProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "creatorProfileCell")
        self.tableView.addInfiniteScrollingWithActionHandler {
            self.loadBelowMore()
        }
        self.loadData()
        self.configureView()
        self.configureFavoriteView()
    }

    func loadFollowUser() {
        
        self.creator?.follower_count = (self.creator?.follower_count)! + 1
        self.is_follow = !(self.is_follow)
        self.loadFavoriteView()
        
    }
    
    func configureView() {
    
        if let profile_image = creator?.profile_image {
            self.avatarImageView.sd_setImageWithURL(NSURL(string: profile_image))
        }else{
            self.avatarImageView.image = UIImage(named: "default")
            
        }
        
        self.nameLabel.text = creator?.name
        if let follower_count = creator?.follower_count {
            self.followerLabel.text = String(follower_count)
        }else{
            self.followerLabel.text = "0"
        }
        
        if let view_count = creator?.view_count {
            self.viewsLabel.text = String(view_count)
        }else{
            self.viewsLabel.text = "0"
        }
        
        if let blast_count = creator?.blast_count {
            self.blastLabel.text = String(blast_count)
        }else{
            self.blastLabel.text = "0"
        }
       
        Utils.makeCircleFromRetacgleView(self.avatarImageView, radius: 50)
        Utils.drawFrameToView(self.favoriteLabel, corner: 10.5, border: 1, color: mainColor)
        
    }
    
    func configureFavoriteView() {
        let request = RequestBuilder()
        request.url = ApiUrl.VALIDATE_FOLLOW_CREATOR
        request.addParameterWithKey("creatorid", value: (self.creator?.creator_id)!)
        request.addParameterWithKey("followerid", value: AppSetting.current_user_id!)
        
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
        
            if responseBuilder.isSuccessful!
            {
                self.is_follow = responseBuilder.validateCreatorFollow()
                self.loadFavoriteView()
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
            }, errorHandler: { (error) in
                
        })
        
    }
    
    func loadFavoriteView() {
        if (self.is_follow){
            self.favoriteLabel.text = "       NON SEGUIRE  "
            self.favoriteLabel.layer.setNeedsLayout()
            self.favoriteIcon.image = UIImage(named: "minus_button")
            for video in videoArray {
                video.is_following_creator = (self.is_follow)
            }
        }else{
            self.favoriteLabel.text = "       SEGUI  "
            self.favoriteLabel.layer.setNeedsLayout()
            self.favoriteIcon.image = UIImage(named: "home_ic_plus_button")
            for video in videoArray {
                video.is_following_creator = (self.is_follow)
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        
        if (self.is_follow) {
            alert1 = UIAlertView(title: "", message: "Non vuoi più seguire " + self.creator!.name! + "?", delegate: self, cancelButtonTitle: "NO", otherButtonTitles: "SI")
            alert1!.show()
            
        }else{
            alert2 = UIAlertView(title: "", message: "Seguire " + self.creator!.name! + "?", delegate: self, cancelButtonTitle: "NO", otherButtonTitles: "SI")
            alert2!.show()
            
        }

    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        let request = RequestBuilder()
        request.url = ApiUrl.FOLLOW_AUTHOR
        request.addParameterWithKey("creatorid", value: (self.creator?.creator_id)!)
        request.addParameterWithKey("followerid", value: AppSetting.current_user_id!)
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                self.is_follow = !(self.is_follow)
                self.loadFavoriteView()
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
            }, errorHandler: { (error) in
                AppUtil.disappearLoadingHud()
                
        })
    }
    
    func loadData() {
        
        self.bucketArray.removeAll()
        
        let request = RequestBuilder()
        request.url = ApiUrl.GET_VIDEO_LIST
        request.addParameterWithKey("page", value: String(offset))
        request.addParameterWithKey("creator_id", value: (creator?.creator_id)!)
        request.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
        
        AppUtil.showLoadingHud()
        ComManager().getVideoList(request, successHandler: { (responseBuilder) in
            if responseBuilder.isSuccessful!
            {
                AppUtil.disappearLoadingHud()
                self.bucketArray = responseBuilder.getVideoList()
                if self.bucketArray.count < 10
                {
                    self.isLoadMore = false
                }else{
                    self.offset = self.offset + 1
                    self.isLoadMore = true
                }
                self.tableView.reloadData()
                self.insertBottom()
            }else{
                AppUtil.disappearLoadingHud()
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
        }) { (error) in
            AppUtil.disappearLoadingHud()
        }
    }
    
    func insertBottom()
    {
        AppUtil.delay(0.2) {[weak self] in
            let count = self?.bucketArray.count
            var i:Int = 0;
            while i < count {
                self?.videoArray.append((self?.bucketArray[i])!)
                let indexPath = NSIndexPath(forRow: self!.videoArray.count - 1, inSection: 0)
                self?.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                i = i + 1
            }
            self?.tableView.infiniteScrollingView.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("creatorProfileCell", forIndexPath: indexPath) as! CreatorProfileTableViewCell
        cell.video = self.videoArray[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 247  
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ViewManager.sharedInstance.showVideoPage(self.videoArray[indexPath.row],homeVC: nil,creatorVC: self)
    }
    //Table View Page Functionality
    func loadBelowMore() {
        self.tableView.infiniteScrollingView.stopAnimating()
        if !isLoadMore {
            self.tableView.infiniteScrollingView.stopAnimating()
            return
        }
        self.loadData()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
