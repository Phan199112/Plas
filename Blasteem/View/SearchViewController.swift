//
//  SearchViewController.swift
//  Blasteem
//
//  Created by k on 8/24/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    var videoArray:[VideoModel] = [VideoModel]()
    var bucketArray:[VideoModel] = [VideoModel]()
    
    @IBOutlet weak var searchView: UIView!
    var offset:Int = 0
    var isLoadMore:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchText.attributedPlaceholder = NSAttributedString(string:"Cerca",
                                                               attributes:[NSForegroundColorAttributeName: mainColor])
        self.tableView.addInfiniteScrollingWithActionHandler {
            self.loadBelowMore()
        }
        self.tableView.registerNib(UINib(nibName: "CategoryDetailTableViewCell",bundle: nil), forCellReuseIdentifier: "categorydetailCell")
        
        self.tableView.keyboardDismissMode = .Interactive
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPointZero, size: CGSizeMake(ScreenSize.SCREEN_WIDTH - 40, 50))
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0).CGColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(rect: self.searchView.bounds).CGPath
        shape.strokeColor = UIColor.blackColor().CGColor
        shape.fillColor = UIColor.clearColor().CGColor
        gradient.mask = shape
        
        self.searchView.layer.addSublayer(gradient)
    }
    
    func loadData() {
        
        self.searchText.resignFirstResponder()
        self.bucketArray.removeAll()
        
        
//        let request = RequestBuilder()
//        request.url = ApiUrl.GET_VIDEO_LIST
//        request.addParameterWithKey("page", value: offset)
//        request.addParameterWithKey("search_text", value: self.searchText.text!)
//        request.addParameterWithKey("userid", value: (AppSetting.current_user_id)!)
//        
//        AppUtil.showLoadingHud()
//        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
//            AppUtil.disappearLoadingHud()
//            if responseBuilder.isSuccessful!
//            {
//                
//                self.bucketArray = responseBuilder.getVideoList()
//                if self.bucketArray.count == 0
//                {
//                    self.isLoadMore = false
//                    self.tableView.reloadData()
//                    AppUtil.showErrorMessage("Nessun risultato trovato")
//                    return
//                }
//                if self.bucketArray.count < 10
//                {
//                    self.isLoadMore = false
//                }else{
//                    self.offset = self.offset + 1
//                    self.isLoadMore = true
//                }
//                self.tableView.reloadData()
//                self.insertBottom()
//                
//            }else{
//                AppUtil.showErrorMessage(responseBuilder.reason!)
//            }
//        }) { (error) in
//            AppUtil.disappearLoadingHud()
//            
//        }
//        
        AppUtil.showLoadingHud()
        let request = RequestBuilder()
        request.url = ApiUrl.GET_VIDEO_LIST
        request.addParameterWithKey("page", value: String(offset))
        
        request.addParameterWithKey("search_text", value: self.searchText.text!)
        request.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
        
        AppUtil.showLoadingHud()
        ComManager().getVideoList(request, successHandler: { (responseBuilder) in
            if responseBuilder.isSuccessful!
            {
                AppUtil.disappearLoadingHud()
                self.bucketArray = responseBuilder.getVideoList()
                if self.bucketArray.count == 0
                {
                    self.isLoadMore = false
                    self.tableView.reloadData()
                    AppUtil.showErrorMessage("Nessun risultato trovato")
                    return
                }
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.searchVideo()
        return false
    }
    @IBAction func onBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    @IBAction func onSearch(sender: AnyObject) {
        
        self.searchVideo()
        
    }
    
    func searchVideo() {
        self.videoArray.removeAll()
        self.bucketArray.removeAll()
        self.view.endEditing(true)
        if !Utils.checkIfStringContainsText(self.searchText.text!) {
            isLoadMore = false
            AppUtil.showErrorMessage("Inserisci un termine di ricerca")
            self.tableView.reloadData()
            return
        }
        self.loadData()
    }

    //UITableView Delegate & DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categorydetailCell", forIndexPath: indexPath) as! CategoryDetailTableViewCell
        cell.video = self.videoArray[indexPath.row]
        cell.video_index = indexPath.row
        // Configure the cell...
        cell.configureCell()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ViewManager.sharedInstance.showVideoPage(self.videoArray[indexPath.row], homeVC: nil, creatorVC: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
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
