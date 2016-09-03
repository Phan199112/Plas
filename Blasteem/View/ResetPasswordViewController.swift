//
//  ResetPasswordViewController.swift
//  Blasteem
//
//  Created by k on 8/26/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func configureView() {
        Utils.makeCircleFromRetacgleView(self.passwordField, radius: 3)
        Utils.makeCircleFromRetacgleView(self.confirmPasswordField, radius: 3)
        Utils.makeCircleFromRetacgleView(self.resetButton, radius: 3)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func onReset(sender: AnyObject) {
        self.view.endEditing(true)
        if !Utils.checkIfStringContainsText(passwordField.text) {
            AppUtil.showErrorMessage("Password(min. 6 caratt.) richiesta")
            return
        }
        
       
        if !Utils.checkIfStringContainsText(confirmPasswordField.text) {
            AppUtil.showErrorMessage("Conferma password richiesta")
            return
        }
        
        //Password Confirm Check
        if passwordField.text != confirmPasswordField.text {
            AppUtil.showErrorMessage("Password e conferma password non coincidono")
            return
        }
        
        if self.passwordField.text?.characters.count < 6 {
            AppUtil.showErrorMessage("La password deve avere almeno 6 caratteri")
            return
        }
        let request = RequestBuilder()
        request.url = ApiUrl.UPDATE_PROFILE
        request.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
        request.addParameterWithKey("user_pass", value: passwordField.text!)
        AppUtil.showLoadingHud()
        
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                
                self.navigationController?.popViewControllerAnimated(true)
                AppUtil.showSuccessMessage("Profilo aggiornato con successo")
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
            
        }) { (error) in
            
        }

    }
    @IBAction func onBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
