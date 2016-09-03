//
//  HomeViewController.swift
//  Blasteem
//
//  Created by k on 8/21/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit
import JDFPeekaboo
class HomeViewController: UIViewController,FilterViewDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var leftConstraints: NSLayoutConstraint!
    @IBOutlet weak var rightConstraints: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var scrollCoordinator:JDFPeekabooCoordinator = JDFPeekabooCoordinator()
    var currentFilter:FilterMenu?{
        didSet{
            self.loadDataFromBegining()
        }
    }
    //Models
    var videoArray:[VideoModel] = [VideoModel]()
    var bucketArray:[VideoModel] = [VideoModel]()
    var filterView:FilterCustomView?
    var offset:Int = 1
    var isLoadMore:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = true
        self.configureView()
        self.tableView.showsInfiniteScrolling = false
        self.tableView.addInfiniteScrollingWithActionHandler {
            
            self.loadBelowMore()
        }
    }
    
    func loadDataFromBegining() {
        self.videoArray = []
        self.bucketArray = []
        self.offset = 1
        isLoadMore = true
        self.loadData()
    }
    
    func loadFavoriteUsers(user_id:Int) {
        var indexPathArray:[NSIndexPath] = []
        var i = 0
        for video in videoArray {
            
            if video.creator?.creator_id == user_id {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                indexPathArray.append(indexPath)
                video.is_following_creator = !video.is_following_creator
            }
            i = i + 1
        }
        self.tableView.reloadRowsAtIndexPaths(indexPathArray, withRowAnimation: .None)
    }
    func configureView() {
        
        filterView = FilterCustomView(frame: CGRectMake(0, 0, ScreenSize.SCREEN_WIDTH + 8   , 70))
        
        self.tableView.contentOffset = CGPointMake(0, -80)
        filterView!.delegate = self
        
        self.view.addSubview(filterView!)
        self.tableView.floatingHeaderView = self.filterView
        self.tableView.registerNib(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
//        if DeviceType.IS_IPHONE_6P {
//            leftConstraints.constant = -20
//            rightConstraints.constant = -20
//        }
        self.currentFilter = FilterMenu.Latest
    }
    
    func loadData() {
        var order_by:String = ""
        
        self.bucketArray.removeAll()
        if currentFilter == FilterMenu.Latest {
            order_by = "latest_post"
        }
        if currentFilter == FilterMenu.Visit {
            order_by = "most_viewed"
        }
        if currentFilter == FilterMenu.Top {
            order_by = "most_liked"
        }
        
        let request = RequestBuilder()
        request.url = ApiUrl.GET_VIDEO_LIST
        request.addParameterWithKey("page", value: String(offset))
        
        request.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
        
        request.addParameterWithKey("orderBy", value: order_by)
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
    
    class func sharedInstace() ->
     HomeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
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
    
    func filterChanged(menu: FilterMenu) {
        if menu == currentFilter {
            return
        }
        offset = 1
        currentFilter = menu
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! HomeTableViewCell
        cell.video = self.videoArray[indexPath.row]
        cell.homeVC = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 336
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ViewManager.sharedInstance.showVideoPage(self.videoArray[indexPath.row],homeVC: self,creatorVC: nil)
    }
    
    //Table View Page Functionality
    func loadBelowMore() {
        self.tableView.infiniteScrollingView.stopAnimating()
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
