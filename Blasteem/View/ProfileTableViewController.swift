//
//  ProfileTableViewController.swift
//  Blasteem
//
//  Created by k on 8/26/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var country_label: UILabel!
    @IBOutlet weak var resetPasswordLabel: UILabel!
    @IBOutlet weak var updateProfileLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    var currentUser:UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.configureView()

        self.loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ProfileTableViewController.profileChanged(_:)), name: "ProfileChangedNotification", object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func profileChanged(notification:NSNotification) -> Void {
        let user =  notification.userInfo!["currentUser"] as! UserModel
        currentUser = user
        self.avatarImageView.image = UIImage(data: user.avatar_data!)
        self.loadViewWithData()
    }
    func loadData() {
        
        let request1 = RequestBuilder()
        
        request1.url = ApiUrl.GET_USER_PROFILE
        request1.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request1, successHandler: { (responseBuilder) in
            if responseBuilder.isSuccessful!{
                self.currentUser = responseBuilder.getUserInfo()
                self.avatarImageView.sd_setImageWithURL(NSURL(string: (self.currentUser?.avatar_url)!))
                self.loadViewWithData()
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
            AppUtil.disappearLoadingHud()
            }, errorHandler: { (error) in
                AppUtil.disappearLoadingHud()
        })
        
    }
    
    func loadViewWithData() {
        
        self.nameLabel.text = ((currentUser?.firstname!)! + " " + (currentUser?.lastname!)!).uppercaseString
        self.usernameLabel.text = currentUser?.username
        self.firstnameLabel.text = currentUser?.firstname
        self.lastnameLabel.text = currentUser?.lastname
        self.emailLabel.text = currentUser?.email
        
        self.countryLabel.text = currentUser?.address
    }
    
    func configureView() {
        Utils.makeCircleFromRetacgleView(avatarImageView, radius: 45)
        Utils.drawFrameToView(self.updateProfileLabel, corner: 10.5, border: 1, color: mainColor)
        Utils.drawFrameToView(self.resetPasswordLabel, corner: 10.5, border: 1, color: mainColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func shouldAutorotate() -> Bool {
        return false
    }

    
    @IBAction func onUpdateProfilePage(sender: AnyObject) {
        ViewManager.sharedInstance.showUpdateProfilePage(currentUser!)
    }
    
    @IBAction func onResetPasswordPage(sender: AnyObject) {
        ViewManager.sharedInstance.showResetPasswordPage()
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
