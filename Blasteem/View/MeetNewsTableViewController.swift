//
//  MeetNewsTableViewController.swift
//  Blasteem
//
//  Created by k on 8/30/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class MeetNewsTableViewController: UITableViewController {

    //Models
    var videoArray:[VideoModel] = [VideoModel]()
    var bucketArray:[VideoModel] = [VideoModel]()
    var offset:Int = 1
    var isLoadMore:Bool = false
    
    var type:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.registerNib(UINib(nibName: "MeetNewsTableViewCell",bundle: nil), forCellReuseIdentifier: "meetnewsCell")
        self.tableView.addInfiniteScrollingWithActionHandler {
            
            self.loadBelowMore()
        }
        self.loadData()
    }
    
    func loadData() {
        
        self.bucketArray.removeAll()
               
        let request = RequestBuilder()
        request.url = type
        request.addParameterWithKey("page", value: String(offset))
        
        AppUtil.showLoadingHud()
        ComManager().getVideoList(request, successHandler: { (responseBuilder) in
            if responseBuilder.isSuccessful!
            {
                AppUtil.disappearLoadingHud()
                self.bucketArray = responseBuilder.getMeetsAndNews(self.type!)
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

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.videoArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("meetnewsCell", forIndexPath: indexPath) as! MeetNewsTableViewCell
        cell.video = self.videoArray[indexPath.row]
        
        return cell

    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 277
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ViewManager.sharedInstance.showWebPage(self.videoArray[indexPath.row].video_url!,title: (self.videoArray[indexPath.row].post_title?.uppercaseString)!)
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
