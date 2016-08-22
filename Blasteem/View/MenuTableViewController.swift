//
//  MenuTableViewController.swift
//  Blasteem
//
//  Created by k on 8/21/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

enum SlideMenu {
    case Profile
    case Creators
    case Meet
    case News
    case Factory
    case Faq
    case Aboutus
    case Logout
    
    static func getAllMenus() -> [SlideMenu]{
        return [SlideMenu.Profile,SlideMenu.Creators,SlideMenu.Meet,SlideMenu.News,SlideMenu.Factory,SlideMenu.Faq,SlideMenu.Aboutus,SlideMenu.Logout]
    }
    static var currentMenu : SlideMenu?
}
class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "LOGIN-BG"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SlideMenu.currentMenu = SlideMenu.getAllMenus()[indexPath.row]
        self.performSegueWithIdentifier("segue_push", sender: nil)
        
    }

 
}
