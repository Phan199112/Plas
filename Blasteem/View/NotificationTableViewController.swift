//
//  NotificationTableViewController.swift
//  Blasteem
//
//  Created by k on 8/30/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {

    weak var mainVC:MainViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.registerNib(UINib(nibName: "NotificationTableViewCell",bundle: nil), forCellReuseIdentifier: "notificationCell")
        
        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadData()
    }

    func loadData() {
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
                self.mainVC!.badgeLabel.backgroundColor = UIColor.clearColor()
                self.mainVC!.badgeLabel.text = ""
                
            }else{
                self.mainVC!.badgeLabel.backgroundColor = UIColor.redColor()
                self.mainVC!.badgeLabel.text = String(responseBuilder.getCountOfUnRead())
                
            }
            self.tableView.reloadData()
            
        }) { (error) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AppSetting.notification_arr.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as? NotificationTableViewCell
        cell?.notification = AppSetting.notification_arr[indexPath.row]
        // Configure the cell...
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let request = RequestBuilder()
        
        request.url = ApiUrl.GET_NOTIFICATIONS
        if let device_token = USER_DEFAULTS.objectForKey("device_token") {
            request.addParameterWithKey("token", value: device_token)
        }else{
            return
        }
        request.addParameterWithKey("os", value: "iOS")
        request.addParameterWithKey("id", value: Int(AppSetting.notification_arr[indexPath.row].blast_id!)!)
        request.addParameterWithKey("viewed", value: "true")
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
           
        }) { (error) in
                
        }
        
        ViewManager.sharedInstance.showVideoPage(AppSetting.notification_arr[indexPath.row], homeVC: nil, creatorVC: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 84
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
