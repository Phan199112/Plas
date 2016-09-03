//
//  CategoryDetailTableViewController.swift
//  Blasteem
//
//  Created by k on 8/22/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class CategoryDetailTableViewController: UITableViewController {
    
    var category_id:Int?
    //Models
    var videoArray:[VideoModel] = [VideoModel]()
    var bucketArray:[VideoModel] = [VideoModel]()
    
    var offset:Int = 0
    var isLoadMore:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.addInfiniteScrollingWithActionHandler {
            self.loadBelowMore()
        }
        self.tableView.registerNib(UINib(nibName: "CategoryDetailTableViewCell",bundle: nil), forCellReuseIdentifier: "categorydetailCell")
        self.loadData()
        
    }
    
    func loadData() {
        
        
        self.bucketArray.removeAll()
        
//        
//        let request = RequestBuilder()
//        request.url = ApiUrl.GET_VIDEO_LIST
//        request.addParameterWithKey("page", value: offset)
//        
//        request.addParameterWithKey("userid", value: (AppSetting.current_user_id)!)
//        request.addParameterWithKey("category_id", value: category_id!)
//        
//        AppUtil.showLoadingHud()
//        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
//            AppUtil.disappearLoadingHud()
//            if responseBuilder.isSuccessful!
//            {
//                self.bucketArray = responseBuilder.getVideoList()
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
        request.addParameterWithKey("category_id", value: String(category_id!))
        request.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
        
        
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
    
    //Table View Page Functionality
    func loadBelowMore() {
        
        if !isLoadMore {
            self.tableView.infiniteScrollingView.stopAnimating()
            return
        }
        self.loadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

  
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.videoArray.count
    }
    override func shouldAutorotate() -> Bool {
        return false
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("categorydetailCell", forIndexPath: indexPath) as! CategoryDetailTableViewCell
        cell.video = self.videoArray[indexPath.row]
        cell.video_index = indexPath.row
        // Configure the cell...
        cell.configureCell()
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ViewManager.sharedInstance.showVideoPage(self.videoArray[indexPath.row], homeVC: nil, creatorVC: nil)
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
