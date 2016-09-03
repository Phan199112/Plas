//
//  UpdateProfileTableViewController.swift
//  Blasteem
//
//  Created by k on 8/26/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class UpdateProfileTableViewController: UITableViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,TOCropViewControllerDelegate,UITextFieldDelegate{
    var homeVC:UpdateProfileHomeViewController?
    @IBOutlet weak var newsCheckImage: UIImageView!
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
    
    @IBOutlet weak var subscriptionCheckButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    var birthdayPicker:UIDatePicker = UIDatePicker()
    var sexPicker:UIPickerView = UIPickerView()
    var addressPicker:UIPickerView = UIPickerView()
    
    //Models
    var currentUser:UserModel?
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
        Utils.makeCircleFromRetacgleView(registerButton, radius: 3)
        
        //Add picker
        birthdayPicker.datePickerMode = .Date
        birthdayPicker.addTarget(self, action: #selector(UpdateProfileTableViewController.datePickerChanged(_:)), forControlEvents:.ValueChanged)
        sexPicker.delegate = self
        addressPicker.delegate = self
        
        sexPicker.dataSource = self
        addressPicker.dataSource = self
//        
//        ageField.inputView = birthdayPicker
//        sexField.inputView = sexPicker
//        addressField.inputView = addressPicker
        ageField.delegate = self
        sexField.delegate = self
        addressField.delegate = self
        //Input Fields
        nameField.text = currentUser?.firstname
        lastnameField.text = currentUser?.lastname
        emailField.text = currentUser?.email
        avatarImageView.sd_setImageWithURL(NSURL(string: (currentUser?.avatar_url)!))
        ageField.text = currentUser?.birthdate?.stringWithFormat("dd-MM-yyyy")
        if currentUser?.sex! == "M" {
            sexField.text = sex_arr[0]
        }else{
            sexField.text = sex_arr[1]
        }
        
        addressField.text = currentUser?.address
        if (currentUser?.is_agreed_news)! {
            isAgreedNews = true
            self.handleCheckBox()
        }
        
        self.tableView.keyboardDismissMode = .Interactive
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
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
    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        print(self.tableView.contentOffset.y)
//        if self.tableView.contentOffset.y > 10 {
//            self.homeVC?.shadowImageView.hidden = false
//        }else{
//            self.homeVC?.shadowImageView.hidden = true
//        }
//    }
    @IBAction func onSubscription(sender: AnyObject) {
        isAgreedNews = !isAgreedNews
        self.handleCheckBox()
    }
    //handle Check Buttons
    func handleCheckBox() {
        if isAgreedNews {
            newsCheckImage.hidden = false
            
        }else{
            newsCheckImage.hidden = true
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onUpdate(sender: AnyObject) {
        //Validation Check
        self.view.endEditing(true)
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

        //Validate Email
        if !Utils.validateEmail(emailField.text) {
            AppUtil.showErrorMessage("Email immessa non valida")
            return
        }
        
        AppUtil.showLoadingHud()
        var gender = "M"
        if sexField.text == sex_arr[1] {
            gender = "F"
        }
        var isNews = "N"
        if isAgreedNews {
            isNews = "Y"
        }
        let request = RequestBuilder()
        request.url = ApiUrl.UPDATE_PROFILE
        request.addParameterWithKey("userid", value: String((AppSetting.current_user_id)!))
        request.addParameterWithKey("first_name", value: nameField.text!)
        request.addParameterWithKey("last_name", value: lastnameField.text!)
        request.addParameterWithKey("user_email", value: emailField.text!)
        request.addParameterWithKey("gender", value: gender)
        request.addParameterWithKey("country", value: addressField.text!)
 
        
        request.addParameterWithKey("blasteem_data_di_nascita", value: ageField.text!)
        
        var imageData:NSData?
        
        request.addParameterWithKey("mailchimp_subscribe", value: isNews)
        
        if avatarImageView.image != nil {
            imageData = UIImageJPEGRepresentation(avatarImageView.image!, 0.5)
            request.addParameterWithKey("user_image", value:"data:image/jpeg;base64," + imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength))
        }
        
        ComManager().postRequestToServer(request, successHandler: { (responseBuilder) in
            AppUtil.disappearLoadingHud()
            if responseBuilder.isSuccessful!
            {
                
                self.currentUser?.firstname = self.nameField.text
                self.currentUser?.lastname = self.lastnameField.text
                self.currentUser?.birthdate = NSDate(fromString:
                    
                self.ageField.text, withFormat: "dd-MM-yyyy")
                self.currentUser?.sex = self.sexField.text
                self.currentUser?.address = self.addressField.text
                self.currentUser?.email = self.emailField.text
                self.currentUser?.avatar_data = imageData!
            NSNotificationCenter.defaultCenter().postNotificationName("ProfileChangedNotification", object: nil,userInfo: ["currentUser":self.currentUser!]   )
                
                self.navigationController?.popViewControllerAnimated(true)
                AppUtil.showSuccessMessage("Profilo aggiornato con successo")
        
            }else{
                AppUtil.showErrorMessage(responseBuilder.reason!)
            }
            
        }) { (error) in
            AppUtil.showErrorMessage("")
        }
        

    }
    override func shouldAutorotate() -> Bool {
        return false
    }

    @IBAction func onChangeAvatar(sender: AnyObject) {
        self.view.endEditing(true)
        
        self.homeVC?.pickerType = "image"
        self.homeVC?.showPickerView()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let cropController = TOCropViewController(croppingStyle: .Default, image: (info[UIImagePickerControllerOriginalImage] as? UIImage)!)
        cropController.delegate = self
         picker.dismissViewControllerAnimated(true) {
            self.presentViewController(cropController, animated: true, completion: nil)
        }
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
