//
//  CreatorListTableViewController.swift
//  Blasteem
//
//  Created by k on 8/23/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class CreatorListTableViewController: UITableViewController {

    var isSubscriptions:Bool = false
    var creatorArray:[CreatorModel] = [CreatorModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationController?.navigationBar.hidden = true
        self.tableView.registerNib(UINib(nibName: "CreatorTableViewCell", bundle: nil), forCellReuseIdentifier: "creatorCell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.isSubscriptions {
            self.loadSubscriptions()
        }else{
            self.loadData()
        }
    }

    func loadSubscriptions()  {
        let request = RequestBuilder()
        request.url = ApiUrl.GET_SUBSCRIPTIONS
        request.addParameterWithKey("userid", value: AppSetting.current_user_id!)
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                self.creatorArray = responseBuilder.getSubscriptions()
                self.tableView.reloadData()
            }else{
                
            }
            }, errorHandler: { (error) in
                AppUtil.disappearLoadingHud()
                
        })
    }
    
    func loadData() {
        let request = RequestBuilder()
        request.url = ApiUrl.GET_CREATORS
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                self.creatorArray = responseBuilder.getCreators()
                self.tableView.reloadData()
            }else{
                
            }
            }, errorHandler: { (error) in
                AppUtil.disappearLoadingHud()
                
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.creatorArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("creatorCell", forIndexPath: indexPath) as? CreatorTableViewCell

        // Configure the cell...
        cell?.creator = self.creatorArray[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        AppSetting.setNone()
        let request = RequestBuilder()
        request.url = ApiUrl.GET_CREATOR_INFO
        request.addParameterWithKey("creatorid", value: (self.creatorArray[indexPath.row].creator_id)!)
        
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                let creator = responseBuilder.getCreatorInfo()
                let origin_creator = self.creatorArray[indexPath.row]
                origin_creator.blast_count = creator.blast_count
                origin_creator.view_count = creator.view_count
                origin_creator.follower_count = creator.follower_count
                
                let creatorDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("CreatorDetailTableViewController") as? CreatorDetailTableViewController
                
                
                creatorDetailVC?.creator = origin_creator
                self.navigationController?.pushViewController(creatorDetailVC!, animated: true)
            }else{
                
            }
            }, errorHandler: { (error) in
                AppUtil.disappearLoadingHud()
                
        })
        
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
