//
//  RegisterHomeViewController.swift
//  Blasteem
//
//  Created by k on 8/20/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import UIKit

class RegisterHomeViewController: UIViewController,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate{
    var currentUser:UserModel?
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var shadowImageView: UIImageView!
    @IBOutlet weak var viewheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var heightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sep1View: UIView!
    
    @IBOutlet weak var malebutton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var birthdayPickerView: UIDatePicker!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var sep2View: UIView!
    @IBOutlet weak var sep3View: UIView!
    
    
    @IBOutlet weak var termsWebView: UIWebView!
    
    @IBOutlet weak var selectButton: UIButton!
    weak var containerVC:RegisterTableViewController?
    
    var pickerType:String = "birthday"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.countryPickerView.delegate = self
        self.countryPickerView.dataSource = self
        
        
        self.birthdayPickerView.subviews[0].subviews[1].backgroundColor = UIColor.whiteColor()
        self.birthdayPickerView.maximumDate = NSDate()
        self.birthdayPickerView.subviews[0].subviews[2].backgroundColor = UIColor.whiteColor()
        Utils.makeCircleFromRetacgleView(self.selectButton, radius: 3)
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            heightConstraints.constant = 10
            leading.constant = 25
            trailing.constant = 25
            viewheightConstraint.constant = 120
        }
    }

    func showPickerView() {
        self.overlayView.hidden = false
        
        switch pickerType {
        case "birthday":
            
            self.typeLabel.text = "Seleziona la data di nascita"
            self.birthdayPickerView.hidden = false
            self.sep1View.hidden = false
            self.sep2View.hidden = true
            self.sep3View.hidden = false
            self.countryPickerView.hidden = true
            self.malebutton.hidden = true
            self.femaleButton.hidden = true
            self.selectButton.hidden = false
            self.termsWebView.hidden = true
            
            break
        case "country":
            
            self.typeLabel.text = "Seleziona la provincia"
            self.birthdayPickerView.hidden = true
            self.sep1View.hidden = false
            self.sep2View.hidden = true
            self.sep3View.hidden = false
            self.countryPickerView.hidden = false
            self.malebutton.hidden = true
            self.femaleButton.hidden = true
            self.selectButton.hidden = false
            
            break
        case "gender":
            
            self.typeLabel.text = "Seleziona il tuo genere"
            self.birthdayPickerView.hidden = true
            self.sep1View.hidden = true
            self.sep2View.hidden = false
            self.sep3View.hidden = true
            self.countryPickerView.hidden = true
            self.malebutton.hidden = false
            self.femaleButton.hidden = false
            self.selectButton.hidden = true
            self.malebutton.setTitle("Maschio", forState: .Normal)
            self.femaleButton.setTitle("Femmina", forState: .Normal)
            self.termsWebView.hidden = true
            
            break
        case "image":
            self.typeLabel.text = "Immagine del profilo"
            self.birthdayPickerView.hidden = true
            self.sep1View.hidden = true
            self.sep2View.hidden = false
            self.sep3View.hidden = true
            self.countryPickerView.hidden = true
            self.malebutton.hidden = false
            self.femaleButton.hidden = false
            self.selectButton.hidden = true
            self.termsWebView.hidden = true
            
            self.malebutton.setTitle("Scatta nuova foto", forState: .Normal)
            self.femaleButton.setTitle("Seleziona foto esistente", forState: .Normal)
            break
        case "terms":
            self.typeLabel.text = "Termini e le condizioni"
            self.selectButton.setTitle("FATTO", forState: .Normal)
            
            self.birthdayPickerView.hidden = true
            self.sep1View.hidden = true
            self.sep2View.hidden = true
            self.sep3View.hidden = true
            self.countryPickerView.hidden = true
            self.malebutton.hidden = true
            self.femaleButton.hidden = true
            self.selectButton.hidden = false
            self.termsWebView.hidden = false
            
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    //PickerViewDelegate and DataSources
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return province_arr.count
        
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return province_arr[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    @IBAction func onBackToLogin(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onSelectButton(sender: AnyObject) {
        switch pickerType {
        case "birthday":
            self.overlayView.hidden = true
            self.containerVC?.ageField.text = self.birthdayPickerView.date.beginningOfDay().stringWithFormat("dd-MM-YYYY")
            
            break
        case "country":
            self.overlayView.hidden = true
           self.containerVC?.addressField.text = province_arr[self.countryPickerView.selectedRowInComponent(0)]
            break
            
        case "terms":
            self.overlayView.hidden = true
            break
        default:
            break
        }
    }

    
    @IBAction func onMale(sender: AnyObject) {
        if pickerType == "gender" {
            self.overlayView.hidden = true
            self.containerVC?.sexField.text = sex_arr[0]
        }else{
            self.overlayView.hidden = true
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .Camera
            
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onFemale(sender: AnyObject) {
        if pickerType == "gender" {
            self.overlayView.hidden = true
            self.containerVC?.sexField.text = sex_arr[1]
        }else{
            self.overlayView.hidden = true
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .PhotoLibrary
            
            imagePicker.delegate = self
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }

    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segue_container" {
            let container = segue.destinationViewController as?RegisterTableViewController
            container?.homeVC = self
            self.containerVC = container
            segue.destinationViewController.setValue(currentUser, forKey: "currentUser")
        }
    }
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        picker.dismissViewControllerAnimated(true) { 
            var imageCropVC : RSKImageCropViewController!
            imageCropVC = RSKImageCropViewController(image: info[UIImagePickerControllerOriginalImage] as! UIImage, cropMode: .Circle)
            imageCropVC.delegate = self
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        }
        
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.navigationController?.popViewControllerAnimated(true)
        containerVC!.currentUser?.avatar_data = UIImageJPEGRepresentation(croppedImage, 0.5)
        containerVC!.avatarImageView.image = croppedImage
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) {
            
        }
        
    }

}
