//
//  ForgotPasswordViewController.swift
//  Blasteem
//
//  Created by k on 8/20/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var middleConstraints: NSLayoutConstraint!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }

    func configureView() -> Void {
        Utils.makeCircleFromRetacgleView(self.usernameView, radius: 3)
        Utils.makeCircleFromRetacgleView(self.sendButton, radius: 3)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            if ScreenSize.SCREEN_HEIGHT / 2 - 120 < keyboardSize.size.height{
                middleConstraints.constant = ScreenSize.SCREEN_HEIGHT / 2 - keyboardSize.size.height - 87
                self.headerView.hidden = true
            }
           
            
        }
        
    }
    
    func keyboardWillHide(notification:NSNotification){
        self.headerView.hidden = false
        middleConstraints.constant = 33
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func onBackToLogin(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func onSend(sender: AnyObject) {
        self.view.endEditing(true)
        if !Utils.checkIfStringContainsText(self.usernameField.text) {
            AppUtil.showErrorMessage("Username o Email richiesta")
            return
        }
        let request = RequestBuilder()
        request.url = ApiUrl.RESET_PASSWORD
        request.addParameterWithKey("username", value: usernameField.text!)
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
                AppUtil.disappearLoadingHud()
                if responseBuilder.isSuccessful!
                {
                    AppUtil.showSuccessMessage(responseBuilder.reason!)
                }else{
                    AppUtil.showErrorMessage(responseBuilder.reason!)
                }
            }) { (error) in
                AppUtil.disappearLoadingHud()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
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
