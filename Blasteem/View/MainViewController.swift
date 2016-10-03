//
//  ViewController.swift
//  Blasteem
//
//  Created by k on 8/17/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit
import Segmentio
class MainViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var segmentioView: Segmentio!
    
    
    var currentIndex:Int = 0
    var currentMenu:SlideMenu?
    var badgeLabel:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupSegmentioView()
        badgeLabel.frame = CGRectMake(ScreenSize.SCREEN_WIDTH - 25, 85, 16, 16)
        badgeLabel.backgroundColor = UIColor.clearColor()
        badgeLabel.textAlignment = .Center
        badgeLabel.textColor = UIColor.whiteColor()
        badgeLabel.font = AppFont.OpenSans_10
        Utils.makeCircleFromRetacgleView(badgeLabel, radius: 8)
        
        self.view.addSubview(badgeLabel)
        
        if ((self.revealViewController()) != nil) {
            
            self.menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchDown)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.addHomeVC()
        self.loadNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MainViewController.slideMenuSelected(_:)), name: "SlideMenuNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MainViewController.loadNotifications), name: "RemoteNotification", object: nil)
        
    }
    
    func receiveRemoteNotification(notification:NSNotification) {
        
        self.loadNotifications()
        
    }
    
    func loadNotifications() {
        if let isforeground = USER_DEFAULTS.objectForKey("isforeground") as? String {
            if isforeground == "no" {
                USER_DEFAULTS.setObject("yes", forKey: "isforeground")
                let video_id = USER_DEFAULTS.objectForKey("video_id") as? String
                if video_id != nil {
                    let video = VideoModel()
                    video.blast_id = video_id
                    self.addNotificationVC()
                    
                    //Inform server video is read
                    let request = RequestBuilder()
                    
                    request.url = ApiUrl.GET_NOTIFICATIONS
                    if let device_token = USER_DEFAULTS.objectForKey("device_token") {
                        request.addParameterWithKey("token", value: device_token)
                    }else{
                        return
                    }
                    
                    request.addParameterWithKey("os", value: "iOS")
                    request.addParameterWithKey("id", value: Int(video.blast_id!)!)
                    request.addParameterWithKey("viewed", value: "true")
                    ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
                        
                    }) { (error) in
                        
                    }
                    ViewManager.sharedInstance.showVideoPage(video, homeVC: nil, creatorVC: nil)
                    
                }
            }
        }
        
        let request = RequestBuilder()
        
        request.url = ApiUrl.GET_NOTIFICATIONS
        if let device_token = USER_DEFAULTS.objectForKey("device_token") {
            request.addParameterWithKey("token", value: device_token)
        }else{
            return
        }
        
        request.addParameterWithKey("os", value: "iOS")
        
        
        ComManager().getRequestToServer(request, successHandler: { (responseBuilder) in
        
            responseBuilder.getNotifications()
            
            UIApplication.sharedApplication().applicationIconBadgeNumber = responseBuilder.getCountOfUnRead()
            if responseBuilder.getCountOfUnRead() == 0
            {
                self.badgeLabel.backgroundColor = UIColor.clearColor()
                self.badgeLabel.text = ""
                
            }else{
                self.badgeLabel.backgroundColor = UIColor.redColor()
                self.badgeLabel.text = String(responseBuilder.getCountOfUnRead())
            }
            
        }) { (error) in
        
        }

    }
 
    func addHomeVC()  {
        AppSetting.setIsHome()
        self.removeViewControllerAsChildViewController()
        let mainStroyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = mainStroyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as? UINavigationController
        
        self.addViewControllerasChild(viewController!)
    }
    func addFavoriteVC()  {
        AppSetting.setIsViews()
        self.removeViewControllerAsChildViewController()
        let mainStroyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = mainStroyboard.instantiateViewControllerWithIdentifier("CreatorNavigationController") as? UINavigationController
        viewController?.viewControllers[0].setValue(true, forKey: "isSubscriptions")
        self.addViewControllerasChild(viewController!)
    }
    func addCategoryVC()  {
        AppSetting.setIsCategories()
        self.removeViewControllerAsChildViewController()
        let mainStroyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = mainStroyboard.instantiateViewControllerWithIdentifier("CategoryNavigationController") as? UINavigationController
        
        self.addViewControllerasChild(viewController!)
    }
    func addNotificationVC()  {
        AppSetting.setIsNotification()
        self.removeViewControllerAsChildViewController()
        let mainStroyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = mainStroyboard.instantiateViewControllerWithIdentifier("NotificationTableViewController") as? NotificationTableViewController
        viewController?.mainVC  = self
        self.addViewControllerasChild(viewController!)
    }
    
    func addCreatorListVC() {
        AppSetting.setNone()
        self.removeViewControllerAsChildViewController()
        let mainStroyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = mainStroyboard.instantiateViewControllerWithIdentifier("CreatorNavigationController") as? UINavigationController
        viewController?.viewControllers[0].setValue(false, forKey: "isSubscriptions")
        self.addViewControllerasChild(viewController!)
    }
    
    func addWebVC(url:String,title:String) {
        AppSetting.setNone()
        ViewManager.sharedInstance.showWebPage(url, title: title)
    }
    
    func addProfileVC() {
        AppSetting.setNone()
        self.removeViewControllerAsChildViewController()
        let mainStroyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = mainStroyboard.instantiateViewControllerWithIdentifier("ProfileTableViewController") as? ProfileTableViewController
        self.addViewControllerasChild(viewController!)
    }
    
    func addMeetsAndNews(type:String) {
        AppSetting.setNone()
        self.removeViewControllerAsChildViewController()
        let mainStroyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = mainStroyboard.instantiateViewControllerWithIdentifier("MeetNewsTableViewController") as? MeetNewsTableViewController
        viewController?.type = type
        self.addViewControllerasChild(viewController!)
    }
    
    private func addViewControllerasChild(viewCtrl:UIViewController) -> Void {
        self.addChildViewController(viewCtrl)
        containerView.addSubview(viewCtrl.view)
        viewCtrl.view.frame = containerView.bounds
        
        viewCtrl.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        viewCtrl.didMoveToParentViewController(self)
    }
    
    private func removeViewControllerAsChildViewController() {
        for view in self.containerView.subviews {
            view.removeFromSuperview()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuSelected(notification:NSNotification) -> Void {
        
        segmentioView.setup(
            content: segmentioContent(),
            style: SegmentioStyle.ImageOverLabel,
            options: segmentioOptions1()
        )
        AppSetting.setNone()
        
        let menu = SlideMenu(rawValue: notification.userInfo!["menu"] as! String)
        if menu == SlideMenu.Profile {
            addProfileVC()
        }
        
        if menu == SlideMenu.Creators {
            addCreatorListVC()
        }
        if menu == SlideMenu.Meet {
            addMeetsAndNews(ApiUrl.GET_MEETS_LIST)
        }
        if menu == SlideMenu.News {
            addMeetsAndNews(ApiUrl.GET_NEWS_LIST)
        }
        if menu == SlideMenu.Factory {
            addWebVC(ApiUrl.BASEURL + ApiUrl.FACTORY,title: "FACTORY")
        }
        if menu == SlideMenu.Faq {
            addWebVC(ApiUrl.BASEURL + ApiUrl.FAQ, title: "F.A.Q")
            
        }
        if menu == SlideMenu.Aboutus {
            addWebVC(ApiUrl.BASEURL + ApiUrl.ABOUTUS,title: "ABOUT US")
            
        }
        if menu == SlideMenu.Logout {
            ViewManager.sharedInstance.showLoginPage()
        }
        
    }
    private func setupSegmentioView() {
        segmentioView.setup(
            content: segmentioContent(),
            style: SegmentioStyle.ImageOverLabel,
            options: segmentioOptions()
        )
        
        segmentioView.selectedSegmentioIndex = 0
        
        segmentioView.valueDidChange = { [weak self] _, segmentIndex in
            
            
            switch segmentIndex {
            case 0:
                if AppSetting.isHome {
                    return
                }
                self!.addHomeVC()
                break
            case 1:
                if AppSetting.isViews {
                    return
                }
                
                self!.addFavoriteVC()
                break
            case 2:
                if AppSetting.isCategories {
                    return
                }
                
                self!.addCategoryVC()
                break
            case 3:
                if AppSetting.isNotifications {
                    return
                }
                
                self!.addNotificationVC()
                break
            default:
                break
            }
        }
    }
    
    private func segmentioContent() -> [SegmentioItem] {
        return [
            SegmentioItem(title: "HOME", image: UIImage(named: "home_ic_tab_home")),
            SegmentioItem(title: "ISCRIZIONI", image: UIImage(named: "views")),
            SegmentioItem(title: "CATEGORIE", image: UIImage(named: "home_ic_tab_categories")),
            SegmentioItem(title: "NOTIFICHE", image: UIImage(named: "home_ic_tab_notification")),

        ]
    }
    //Segment Setting Related
    private func segmentioOptions() -> SegmentioOptions {
        let imageContentMode = UIViewContentMode.ScaleAspectFit
        return SegmentioOptions(
            backgroundColor: UIColor.clearColor(),
            maxVisibleItems: 4,
            scrollEnabled: true,
            indicatorOptions: segmentioIndicatorOptions(),
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
            imageContentMode: imageContentMode,
            labelTextAlignment: .Center,
            segmentStates: segmentioStates()
        )
    }
    
    private func segmentioOptions1() -> SegmentioOptions {
        let imageContentMode = UIViewContentMode.ScaleAspectFit
        return SegmentioOptions(
            backgroundColor: UIColor.clearColor(),
            maxVisibleItems: 4,
            scrollEnabled: true,
            indicatorOptions: segmentioIndicatorOptions(),
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
            imageContentMode: imageContentMode,
            labelTextAlignment: .Center,
            segmentStates: segmentioStates()
        )
    }
    
    private func segmentioStates() -> SegmentioStates {
        
        var font = UIFont.systemFontOfSize(12)
        if DeviceType.IS_IPHONE_4_OR_LESS {
            font = UIFont.systemFontOfSize(10)
        }
        if DeviceType.IS_IPHONE_5 {
            font = UIFont.systemFontOfSize(11)
        }
        return SegmentioStates(
            defaultState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: UIColor.whiteColor()
            ),
            selectedState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: UIColor.whiteColor()
            ),
            highlightedState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: UIColor.whiteColor()
            )
        )
    }
    
    private func segmentioState(backgroundColor backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(backgroundColor: backgroundColor, titleFont: titleFont, titleTextColor: titleTextColor)
    }
    
    private func segmentioIndicatorOptions() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(
            type: .Bottom,
            ratio: 1,
            height: 5,
            color: mainColor
        )
    }
    
    private func segmentioIndicatorOptions1() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(
            type: .Bottom,
            ratio: 0,
            height: 5,
            color: mainColor
        )
    }
    
    private func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(
            type: .TopAndBottom,
            height: 0,
            color: UIColor.whiteColor()
        )
    }
    
    private func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(
            ratio: 0,
            color: UIColor.whiteColor()
        )
    }
    @IBAction func onSearch(sender: AnyObject) {
        let searchVC = self.storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as? SearchViewController
        self.navigationController?.pushViewController(searchVC!, animated: false)
        
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
//     override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool {
//        return UIInterfaceOrientationIsPortrait(interfaceOrientation)
//    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

}

