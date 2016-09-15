//
//  RegisterTableViewController.swift
//  Blasteem
//
//  Created by k on 8/18/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,TOCropViewControllerDelegate, UITextFieldDelegate{

    var homeVC:RegisterHomeViewController?
    @IBOutlet weak var avatarView: UIView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var lastnameView: UIView!
    @IBOutlet weak var lastnameField: UITextField!
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageField: UITextField!
    
    
    @IBOutlet weak var sexView: UIView!
    @IBOutlet weak var sexField: UITextField!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressField: UITextField!
    
    @IBOutlet weak var emailview: UIView!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPassView: UIView!
    @IBOutlet weak var confirmPassField: UITextField!
    
    @IBOutlet weak var termsCheckImage: UIImageView!
    @IBOutlet weak var termsCheckButton: UIButton!
    
    @IBOutlet weak var subscriptionCheckImage: UIImageView!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var birthdayPicker:UIDatePicker = UIDatePicker()
    var sexPicker:UIPickerView = UIPickerView()
    var addressPicker:UIPickerView = UIPickerView()
    
    //Models
    var currentUser:UserModel?
    var isAgreedTerms = false
    var isAgreedNews = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.configureView()
    }
   
    func configureView() {
//        self.tableView.backgroundView = UIImageView(image: UIImage(named: "LOGIN-BG"))
        Utils.makeCircleFromRetacgleView(avatarView, radius: 3)
        Utils.makeCircleFromRetacgleView(nameView, radius: 3)
        Utils.makeCircleFromRetacgleView(lastnameView, radius: 3)
        Utils.makeCircleFromRetacgleView(ageView, radius: 3)
        Utils.makeCircleFromRetacgleView(sexView, radius: 3)
        Utils.makeCircleFromRetacgleView(addressView, radius: 3)
        Utils.makeCircleFromRetacgleView(emailview, radius: 3)
        Utils.makeCircleFromRetacgleView(usernameView, radius: 3)
        Utils.makeCircleFromRetacgleView(passwordView, radius: 3)
        Utils.makeCircleFromRetacgleView(confirmPassView, radius: 3)
        Utils.makeCircleFromRetacgleView(registerButton, radius: 3)
        
        //Add picker
        birthdayPicker.datePickerMode = .Date
        birthdayPicker.addTarget(self, action: #selector(RegisterTableViewController.datePickerChanged(_:)), forControlEvents:.ValueChanged)
        sexPicker.delegate = self
        addressPicker.delegate = self
        
        sexPicker.dataSource = self
        addressPicker.dataSource = self
        
        ageField.inputView = birthdayPicker
        sexField.inputView = sexPicker
        addressField.inputView = addressPicker
        
        
        //When Facebook or Google
        if currentUser != nil {
            
            nameField.text = currentUser?.firstname
            lastnameField.text = currentUser?.lastname
            emailField.text = currentUser?.email
            avatarImageView.sd_setImageWithURL(NSURL(string: (currentUser?.avatar_url)!))
            ageField.text = currentUser?.birthdate?.stringWithFormat("dd-MM-yyyy")
            sexField.text = currentUser?.sex
        }
        
        self.tableView.keyboardDismissMode = .Interactive
    }
    
    func datePickerChanged(pickerView:UIDatePicker) -> Void {
        ageField.text = birthdayPicker.date.beginningOfDay().stringWithFormat("dd-MM-YYYY")
    }
    //PickerViewDelegate and DataSources
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case sexPicker:
            return sex_arr.count
        case addressPicker:
            return province_arr.count
        default:
            return 0
            
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case sexPicker:
            sexField.text = sex_arr[row]
        case addressPicker:
            addressField.text = province_arr[row]
            
        default:
            break
            
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == self.sexField {
            
            self.homeVC?.pickerType = "gender"
            self.homeVC?.showPickerView()
            return false
        }
        
        if textField == self.ageField {
            self.homeVC?.pickerType = "birthday"
            self.homeVC?.showPickerView()
            
            return false
        }
        
        if textField == self.addressField {
            self.homeVC?.pickerType = "country"
            self.homeVC?.showPickerView()
            
            return false
        }
        return true
        
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case sexPicker:
            return sex_arr[row]
        case addressPicker:
            return province_arr[row]
        default:
            return nil
            
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    //handle Check Buttons
    func handleCheckBox() {
        if isAgreedNews {
            subscriptionCheckImage.hidden = false
            
        }else{
            subscriptionCheckImage.hidden = true
        }
        if isAgreedTerms {
            termsCheckImage.hidden = false
        }else{
            termsCheckImage.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBackLogin(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    @IBAction func onTerms(sender: AnyObject) {
        isAgreedTerms = !isAgreedTerms
        self.handleCheckBox()
    }
    @IBAction func onSubscription(sender: AnyObject) {
        isAgreedNews = !isAgreedNews
        self.handleCheckBox()
    }
    @IBAction func onRegister(sender: AnyObject) {
        self.view.endEditing(true)
        //Validation Check
        if !Utils.checkIfStringContainsText(nameField.text) {
            AppUtil.showErrorMessage("Nome richiesto")
            return
        }
        if !Utils.checkIfStringContainsText(lastnameField.text) {
            AppUtil.showErrorMessage("Cognome richiesto")
            return
        }
        if !Utils.checkIfStringContainsText(ageField.text) {
            AppUtil.showErrorMessage("Età richiesta")
            return
        }
        if !Utils.checkIfStringContainsText(sexField.text) {
            AppUtil.showErrorMessage("Sesso richiesto")
            return
        }
        if !Utils.checkIfStringContainsText(addressField.text) {
            AppUtil.showErrorMessage("Provincia richiesta")
            return
        }
        if !Utils.checkIfStringContainsText(emailField.text) {
            AppUtil.showErrorMessage("Email richiesta")
            return
        }
        if !Utils.checkIfStringContainsText(usernameField.text) {
            AppUtil.showErrorMessage("Username richiesta")
            return
        }
        if !Utils.checkIfStringContainsText(passwordField.text) {
            AppUtil.showErrorMessage("Password(min. 6 caratt.) richiesta")
            return
        }
        if !Utils.checkIfStringContainsText(confirmPassField.text) {
            AppUtil.showErrorMessage("Conferma password richiesta")
            return
        }
        
        //Validate Email
        if !Utils.validateEmail(emailField.text) {
            AppUtil.showErrorMessage("Email immessa non valida")
            return
        }
        //Password Confirm Check
        if passwordField.text != confirmPassField.text {
            AppUtil.showErrorMessage("Password e conferma password non coincidono")
            return
        }
        
        if passwordField.text?.characters.count < 6 {
            AppUtil.showErrorMessage("La password deve avere almeno 6 caratteri")
            return
        }
        
        //Terms Check
        if !isAgreedTerms {
            AppUtil.showErrorMessage("Devi accettare i T&C di Blasteem per procedere")
            return
        }
        AppUtil.showLoadingHud()
        var gender = "M"
        if sexField.text == sex_arr[1] {
            gender = "F"
        }
        var isNews:String = "N"
        if isAgreedNews {
            isNews = "Y"
        }
        let request = RequestBuilder()
        request.url = ApiUrl.REGISTER
        request.addParameterWithKey("first_name", value: nameField.text!)
        request.addParameterWithKey("last_name", value: lastnameField.text!)
        request.addParameterWithKey("user_email", value: emailField.text!)
        request.addParameterWithKey("gender", value: gender)
        request.addParameterWithKey("country", value: addressField.text!)
        request.addParameterWithKey("user_login", value: usernameField.text!)
        request.addParameterWithKey("user_pass", value: passwordField.text!)
        request.addParameterWithKey("terms", value: "Y")
        request.addParameterWithKey("blasteem_data_di_nascita", value: ageField.text!)
        
        var imageData:NSData?
        
        request.addParameterWithKey("mailchimp_subscribe", value: isNews)
        
        if currentUser != nil {
            if currentUser?.fb_id != nil {
                request.addParameterWithKey("id", value: (currentUser?.fb_id)!)
                request.url = ApiUrl.REGISTER_FB
                if currentUser?.avatar_url != nil {
                    request.addParameterWithKey("profilepicture", value: (currentUser?.avatar_url)!)
                }
            }
            
            if currentUser?.google_id != nil {
                request.addParameterWithKey("id", value: (currentUser?.google_id)!)
                if currentUser?.avatar_url != nil {
                    request.addParameterWithKey("image-url", value: (currentUser?.avatar_url)!)
                }
                request.url = ApiUrl.REGISTER_GOOGLE
            }
            
        }else{
            if avatarImageView.image != nil {
                imageData = UIImageJPEGRepresentation(avatarImageView.image!, 0.5)
                request.addParameterWithKey("user_image", value:"data:image/jpeg;base64," + imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))
            }
        }
        
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                if self.currentUser == nil
                {
                    self.currentUser = UserModel(user_id: nil, fb_id: nil, google_id: nil, avatar_url: nil, avatar_data:imageData, firstname: self.nameField.text, lastname: self.lastnameField.text, birthdate: NSDate(fromString: self.ageField.text, withFormat: "dd-MM-yyyy"), sex: self.sexField.text, address: self.addressField.text, email: self.emailField.text, username: self.usernameField.text, password: self.passwordField.text, user_link:nil)
                    
                } else{
                    self.currentUser?.firstname = self.nameField.text
                    self.currentUser?.lastname = self.lastnameField.text
                    self.currentUser?.birthdate = NSDate(fromString: self.ageField.text, withFormat: "dd-MM-yyyy")
                    self.currentUser?.sex = self.sexField.text
                    self.currentUser?.address = self.addressField.text
                    self.currentUser?.email = self.emailField.text
                    self.currentUser?.username = self.usernameField.text
                    self.currentUser?.password = self.passwordField.text
                    
                }
                self.currentUser?.is_agreed_news = self.isAgreedNews
                ApplicationDelegate.restClient?.linkWithUrl(ApiUrl.BASEURL + "pnfw/register/", andEmail: (self.currentUser?.email)!)
                responseBuilder.registerResponseHandler(self.currentUser!)
                
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
            
        }) { (error) in
            AppUtil.showErrorMessage("")
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        print(self.tableView.contentOffset.y)
        if self.tableView.contentOffset.y > 10 {
            self.homeVC?.shadowImageView.hidden = false
        }else{
            self.homeVC?.shadowImageView.hidden = true
        }
    }
    
    
    @IBAction func onChangeAvatar(sender: AnyObject) {
        self.view.endEditing(true)
        
        if currentUser != nil {
            return
        }
        self.homeVC?.pickerType = "image"
        self.homeVC?.showPickerView()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        currentUser?.avatar_data = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage] as! UIImage, 0.5)
        self.avatarImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func cropViewController(cropViewController: TOCropViewController!, didCropToImage image: UIImage!, withRect cropRect: CGRect, angle: Int) {
        cropViewController.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        currentUser?.avatar_data =
            UIImageJPEGRepresentation(image, 0.5)
        
        self.avatarImageView.image = image
        
    }
    @IBAction func onGetTerms(sender: AnyObject) {
        self.view.endEditing(true)
        let request = RequestBuilder()
        request.url = ApiUrl.GET_TERMS
        AppUtil.showLoadingHud()
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                let terms = responseBuilder.response!["terms_and_conditions"] as! String
                self.homeVC?.pickerType = "terms"
                self.homeVC?.showPickerView()
                
                self.homeVC?.termsWebView.loadHTMLString(terms, baseURL: nil)
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
            }) { (error) in
            AppUtil.disappearLoadingHud()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

}
