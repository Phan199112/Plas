//
//  RootNavViewController.swift
//  Blasteem
//
//  Created by k on 8/20/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class RootNavViewController: UINavigationController {

    var isLandScape:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func shouldAutorotate() -> Bool {
        return isLandScape
    }
    //     override func shouldAutorotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation) -> Bool {
    //        return UIInterfaceOrientationIsPortrait(interfaceOrientation)
    //    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if isLandScape {
            return UIInterfaceOrientationMask.All
        }else{
            return UIInterfaceOrientationMask.Portrait
        }
        
    }

}
