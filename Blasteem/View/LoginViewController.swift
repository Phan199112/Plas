//
//  LoginViewController.swift
//  Blasteem
//
//  Created by k on 8/18/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit
import ZProgressHUD
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class LoginViewController: UIViewController ,GIDSignInDelegate ,GIDSignInUIDelegate{

    @IBOutlet weak var authView: UIView!
    
    //Buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    //TextFields
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //Constraints
    @IBOutlet weak var constraintsbetweenlogoandview: NSLayoutConstraint!
    @IBOutlet weak var intervalConstraints: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureView()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func configureView() {
        Utils.makeCircleFromRetacgleView(authView, radius: 2)
        if DeviceType.IS_IPHONE_4_OR_LESS {
            topConstraint.constant = -85
            intervalConstraints.constant = 16
        }else if DeviceType.IS_IPHONE_5{
            topConstraint.constant = -135
            intervalConstraints.constant = 30
        }else if DeviceType.IS_IPHONE_6{
            topConstraint.constant = -150
            intervalConstraints.constant = 48
            constraintsbetweenlogoandview.constant = 50
        }else{
            intervalConstraints.constant = 60
            constraintsbetweenlogoandview.constant = 70
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
//        AppUtil.disappearLoadingHud()
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        self.view.endEditing(true)
        if !Utils.checkIfStringContainsText(usernameField.text){
            AppUtil.showErrorMessage("Username richiesta")
            return
        }
        
        if !Utils.checkIfStringContainsText(passwordField.text) {
            AppUtil.showErrorMessage("Password richiesta")
            return
        }
        
        AppUtil.showLoadingHud()
        let request = RequestBuilder()
        request.url = ApiUrl.VALIDATE_USER
        request.addParameterWithKey("username", value: usernameField.text!)
        request.addParameterWithKey("password", value: passwordField.text!)
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            
                            if responseBuilder.isSuccessful!
                            {
                                AppSetting.current_user_id = responseBuilder.loginResponseHandler()
                                let request1 = RequestBuilder()
                                
                                request1.url = ApiUrl.GET_USER_PROFILE
                                request1.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
                                AppUtil.showLoadingHud()
                                ComManager().postRequestToServer(request1, successHandler: { (responseBuilder) in
                                    if responseBuilder.isSuccessful!{
                                        AppSetting.currentUser = responseBuilder.getUserInfo()
                                        ApplicationDelegate.restClient?.linkWithUrl(ApiUrl.BASEURL + "pnfw/register/", andEmail: (AppSetting.currentUser?.email)!)
                                        
                                        self.performSegueWithIdentifier("segue_login_home", sender: nil)
                                        
                                    }else{
                                        AppUtil.showErrorMessage(responseBuilder.reason!)
                                    }
                                    AppUtil.disappearLoadingHud()
                                    }, errorHandler: { (error) in
                                        AppUtil.disappearLoadingHud()
                                })
                                //Go To Home Page
                                
                            }else{
                                AppUtil.disappearLoadingHud()
                                AppUtil.showErrorMessage(responseBuilder.reason!)
                            }
                            }, errorHandler: { (error) in
                                
                            AppUtil.disappearLoadingHud()
                            
                        })
    }
    
    @IBAction func onLoginWithFacebook(sender: AnyObject) {
        
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile","email","user_birthday"], fromViewController: self) { (result, error) in
            if (error != nil)
            {
                AppUtil.showErrorMessage("Facebook Login Error")
            }else if result.isCancelled {
                
                AppUtil.showErrorMessage("Facebook Login Cancelled")
            }else{
                AppUtil.showLoadingHud()
                let request = FBSDKGraphRequest(graphPath: "me/", parameters: ["fields":"cover,picture.type(large),id,name,first_name,last_name,gender,birthday,email,location,hometown,bio,photos"])
                request.startWithCompletionHandler({ (connection, result, error) in
                    if (error == nil)
                    {
                        
                        
                        let userData = result as! NSDictionary
                        let email = userData["email"] as? String
                        let facebookID = userData["id"] as? String
                        let first_name = userData["first_name"] as? String
                        let birth_day = userData["birth_day"] as? String
                        let birth_day_date = NSDate(fromString: birth_day, withFormat: "MM/dd/yyyy")
                        let last_name = userData["last_name"] as? String
                        let pictureUrl = "https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1" + facebookID!
                        let user_link = userData["link"] as? String
                        let currentUser:UserModel = UserModel(user_id: nil, fb_id: facebookID, google_id: nil, avatar_url: pictureUrl, avatar_data: nil, firstname: first_name, lastname: last_name, birthdate: birth_day_date, sex: nil, address: nil, email: email, username: nil, password: nil, user_link: user_link)
                        
                        let request = RequestBuilder()
                        request.url = ApiUrl.VALIDATE_FB
                        request.addParameterWithKey("facebook_id", value: facebookID!)
                        request.addParameterWithKey("user_email", value: email!)
                        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
                            AppUtil.disappearLoadingHud()
                            if responseBuilder.isSuccessful!
                            {
                                if responseBuilder.validateSocialUser(){
                                    let request1 = RequestBuilder()
                                    
                                    request1.url = ApiUrl.GET_USER_PROFILE
                                    request1.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
                                    AppUtil.showLoadingHud()
                                    ComManager().postRequestToServer(request1, successHandler: { (responseBuilder) in
                                        if responseBuilder.isSuccessful!{
                                            AppSetting.currentUser = responseBuilder.getUserInfo()
                                            ApplicationDelegate.restClient?.linkWithUrl(ApiUrl.BASEURL + "pnfw/register/", andEmail: (AppSetting.currentUser?.email)!)
                                            
                                            self.performSegueWithIdentifier("segue_login_home", sender: nil)
                                            
                                        }else{
                                            AppUtil.showErrorMessage(responseBuilder.reason!)
                                        }
                                        AppUtil.disappearLoadingHud()
                                        }, errorHandler: { (error) in
                                            AppUtil.disappearLoadingHud()
                                    })

                                }else{
                                    self.performSegueWithIdentifier("segue_login_register", sender: currentUser)
                                }
                                
//                                //Go To Home Page
//                                let request1 = RequestBuilder()
//                                request1.url = ApiUrl.GET_ME + String(responseBuilder.loginResponseHandler())
//                                
//                                ComManager().getRequestToServer(request1, successHandler: { (responseBuilder) in
//                                    AppUtil.disappearLoadingHud()
//                                    
//                                    
//                                    responseBuilder.getUserInfo()
//                                    
//                                    self.performSegueWithIdentifier("segue_login_home", sender: nil)
//                                    
//                                    }, errorHandler: { (error) in
//                                        AppUtil.disappearLoadingHud()
//                                })
                            }else{
                                AppUtil.showErrorMessage(responseBuilder.reason!)
                            }
                            }, errorHandler: { (error) in
                            AppUtil.disappearLoadingHud()
                        })
                        
                    }else{
                        AppUtil.showErrorMessage("Facebook Login Error")
                    }
                })
            }
        }
    }

    @IBAction func onLoginWithGoogle(sender: AnyObject) {
        let signManager = GIDSignIn.sharedInstance()
        signManager.scopes.append("https://www.googleapis.com/auth/userinfo.profile")
        signManager.signIn()
    }
    @IBAction func onForgotPassword(sender: AnyObject) {
        
    }
    @IBAction func onGoRegister(sender: AnyObject) {
        self.performSegueWithIdentifier("segue_login_register", sender: nil)
    }
    
    
    //--Google Signin Delegate
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            
            let userimage = user.profile.valueForKey("imageURL") as? String
            // ...
            
            let currentUser:UserModel = UserModel(user_id: nil, fb_id: nil, google_id: userId, avatar_url: userimage, avatar_data: nil, firstname: givenName, lastname: familyName, birthdate: nil, sex: nil, address: nil, email: email, username: nil, password: nil,user_link: nil)
            let request = RequestBuilder()
            request.url = ApiUrl.VALIDATE_GOOGLE
            request.addParameterWithKey("google_id", value: userId!)
            request.addParameterWithKey("user_email", value: email!)
            AppUtil.showLoadingHud()
            ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
                AppUtil.disappearLoadingHud()
                if responseBuilder.isSuccessful!
                {
                    if responseBuilder.validateSocialUser()
                    {
                        let request1 = RequestBuilder()
                        
                        request1.url = ApiUrl.GET_USER_PROFILE
                        request1.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
                        AppUtil.showLoadingHud()
                        ComManager().postRequestToServer(request1, successHandler: { (responseBuilder) in
                            if responseBuilder.isSuccessful!{
                                AppSetting.currentUser = responseBuilder.getUserInfo()
                                ApplicationDelegate.restClient?.linkWithUrl(ApiUrl.BASEURL + "pnfw/register/", andEmail: (AppSetting.currentUser?.email)!)
                                
                                self.performSegueWithIdentifier("segue_login_home", sender: nil)
                                
                            }else{
                                AppUtil.showErrorMessage(responseBuilder.reason!)
                            }
                            AppUtil.disappearLoadingHud()
                            }, errorHandler: { (error) in
                                AppUtil.disappearLoadingHud()
                        })
                    }else{
                        self.performSegueWithIdentifier("segue_login_register", sender: currentUser)
                    }
                    
                }else{
                    AppUtil.showErrorMessage(responseBuilder.reason!)
                }
                
                }, errorHandler: { (error) in
                    AppUtil.disappearLoadingHud()
            })
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segue_login_register" {
            if sender != nil {
                segue.destinationViewController .setValue(sender as! UserModel, forKey: "currentUser")
    
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

}
