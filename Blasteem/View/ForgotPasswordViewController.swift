//
//  ForgotPasswordViewController.swift
//  Blasteem
//
//  Created by k on 8/20/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    func configureView() -> Void {
        Utils.makeCircleFromRetacgleView(self.usernameView, radius: 3)
        
    }
    
    @IBAction func onBackToLogin(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func onSend(sender: AnyObject) {
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
                    AppUtil.showSuccess(responseBuilder.reason!)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
