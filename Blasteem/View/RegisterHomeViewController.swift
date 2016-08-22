//
//  RegisterHomeViewController.swift
//  Blasteem
//
//  Created by k on 8/20/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class RegisterHomeViewController: UIViewController {
    var currentUser:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onBackToLogin(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segue_container" {
            segue.destinationViewController.setValue(currentUser, forKey: "currentUser")
        }
    }
    

}
